module Projects
  class SyncProjectJob
    include Sidekiq::Job

    def perform(project_id)

      @project = Project.find(project_id)
      @cluster = Cluster.find(@project.cluster_id)
      @project.update(status: 'provisioning')

      ensure_namespace
      ensure_infrastructure
      ensure_cluster

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
      template = %q{
vcluster:
  extraArgs:
   - "--kube-apiserver-arg=--oidc-username-claim=preferred_username"
   - "--kube-apiserver-arg=--oidc-issuer-url=https://launchboxhq.local"
   - "--kube-apiserver-arg=--oidc-client-id=lNylsUBcv_6pFwITm2CxTOGd3k_tr7kmeG4TJp4gruk"
   - "--kube-apiserver-arg=--oidc-username-claim=email"
   - "--kube-apiserver-arg=--oidc-groups-claim=groups"
  resources:
    limits:
      cpu: <%= @project.cpu %>
      memory: "<%= @project.memory %>Mi"
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
}
      ryaml = ERB.new(template)
      b = binding
      b.local_variable_set(:project, @project)
      ryaml.result(b)
    end
  end
end
