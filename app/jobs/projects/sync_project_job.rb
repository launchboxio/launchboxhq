module Projects
  class SyncProjectJob
    include Sidekiq::Job

    def perform(project_id)

      @project = Project.find(project_id)
      @cluster = Cluster.find(@project.cluster_id)
      @project.update(status: 'provisioning')

      # Create our resources
      ensure_namespace
      ensure_infrastructure
      ensure_cluster

      # Backfill our project with the information from the generated cluster
      client = @cluster.get_client("", "v1")
      loop do
        begin
          secret = client.get_secret("vc-#{@project.slug}", @project.slug)
          @project.update(ca_crt: secret.data['certificate-authority'])
          break
        rescue Kubeclient::HttpError => e
          puts e
          # Handle all errors except for "Not Found"
          if e.error_code != 404
            @project.update(status: "failed")
            raise
          end

          sleep 1
        end
      end


      @project.update(status: 'provisioned')
    end

    def ensure_namespace
      namespace = Kubeclient::Resource.new(
        kind: 'Namespace',
        metadata: {
          name: @project.slug
        }
      )
      client = @cluster.get_client("", "v1")
      puts client.api_endpoint.host
      puts client.api_endpoint.path
      begin
        client.create_namespace(namespace)
      rescue
        client.update_namespace(namespace)
      end
    end

    def ensure_infrastructure
      client = @cluster.get_client("/apis/infrastructure.cluster.x-k8s.io", 'v1alpha1')
      puts client.api_endpoint.host
      puts client.api_endpoint.path
      resource = Kubeclient::Resource.new(
        metadata: {
          name: @project.slug,
          namespace: @project.slug
        },
        spec: {
          controlPlaneEndpoint: {
            host: "",
            port: 0
          },
          helmRelease: {
            chart: {},
            values: values
          },
          kubernetesVersion: '1.23.0'
        }
      )
      begin
        client.create_vcluster(resource)
      rescue Kubeclient::HttpError => e
        if e.error_code == 409
          existing = client.get_vcluster @project.slug, @project.slug
          existing.spec = resource.spec
          client.update_vcluster(existing)
        end
      end
    end

    def ensure_cluster
      client = @cluster.get_client("/apis/cluster.x-k8s.io", 'v1beta1')
      resource = Kubeclient::Resource.new({
        metadata: {
          name: @project.slug,
          namespace: @project.slug
        },
        spec: {
          controlPlaneRef: {
            apiVersion: 'infrastructure.cluster.x-k8s.io/v1alpha1',
            kind: 'VCluster',
            name: @project.slug,
          },
          infrastructureRef: {
            apiVersion: 'infrastructure.cluster.x-k8s.io/v1alpha1',
            kind: 'VCluster',
            name: @project.slug,
          }
        }
      })
      begin
        client.create_cluster(resource)
      rescue Kubeclient::HttpError => e
        if e.error_code == 409
          existing = client.get_cluster @project.slug, @project.slug
          existing.spec = resource.spec
          client.update_cluster(existing)
        end
      end
    end

    def values
      # TODO: Add manifests for users
      # TODO: Add manifests for giving launchbox admin access
      template = '
vcluster:
  extraArgs:
   - "--kube-apiserver-arg=--oidc-username-claim=preferred_username"
   - "--kube-apiserver-arg=--oidc-issuer-url=https://launchboxhq.local"
   - "--kube-apiserver-arg=--oidc-client-id=lNylsUBcv_6pFwITm2CxTOGd3k_tr7kmeG4TJp4gruk"
   - "--kube-apiserver-arg=--oidc-ca-file=/oidc-certs/ca.crt"
   - "--kube-apiserver-arg=--oidc-username-claim=email"
   - "--kube-apiserver-arg=--oidc-groups-claim=groups"
  resources:
    limits:
      cpu: <%= @project.cpu %>
      memory: "<%= @project.memory %>Mi"
  volumeMounts:
    - mountPath: /data
      name: data
    - name: launchbox-local-tls
      mountPath: "/oidc-certs"
      readOnly: true
storage:
  persistence: true
  size: "<%= @project.disk %>Gi"
sync:
  ingresses:
    enabled: true
  serviceaccounts:
    enabled: true
ingress:
  enabled: true
  ingressClassName: "nginx"
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
  host: "api.<%= @project.slug %>.launchboxhq.local"
volumes:
  - name: launchbox-local-tls
    secret:
      secretName: root-secret
      items:
      - key: ca.crt
        path: ca.crt
init:
  manifests: |
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: admins
    subjects:
    - kind: User
      name: <%= @project.user.email %>
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: cluster-admin
      apiGroup: rbac.authorization.k8s.io
'
      ryaml = ERB.new(template)
      b = binding
      b.local_variable_set(:project, @project)
      ryaml.result(b)
    end
  end
end
