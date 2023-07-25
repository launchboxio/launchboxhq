module Projects
  class SyncProjectJob < ApplicationJob
    queue_as :default

    def perform(*args)
      timeout = 300

      @project = Project.find(args.first)
      @cluster = Cluster.find(@project.cluster_id)
      @project.update(status: 'provisioning')
      cert_store = OpenSSL::X509::Store.new
      cert_store.add_cert(OpenSSL::X509::Certificate.new(@cluster.ca_crt))
      @options = {
        auth_options: { bearer_token: @cluster.token },
        ssl_options: {
          cert_store: cert_store,
          verify_ssl: OpenSSL::SSL::VERIFY_PEER
        }
      }

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
      client = Kubeclient::Client.new(@cluster.host, 'v1', **@options)
      begin
        client.create_namespace(namespace)
      rescue
        client.update_namespace(namespace)
      end
    end

    def ensure_infrastructure
      client = Kubeclient::Client.new("#{@cluster.host}/apis/infrastructure.cluster.x-k8s.io", 'v1alpha1', **@options)
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
      client = Kubeclient::Client.new("#{@cluster.host}/apis/cluster.x-k8s.io", 'v1beta1', **@options)
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
  extraArgs: []
#    - "--kube-apiserver-arg=--oidc-username-claim=preferred_username"
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
