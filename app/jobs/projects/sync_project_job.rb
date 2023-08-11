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
          # Handle all errors except for "Not Found"
          if e.error_code != 404
            @project.update(status: "failed")
            raise
          end

          sleep 1
        end
      end

      ensure_provider_config("/apis/kubernetes.crossplane.io", 'v1alpha1')
      ensure_provider_config("/apis/helm.crossplane.io", 'v1beta1')

      @project.update(status: 'provisioned')

      apply_addon_subscriptions
    end

    def ensure_namespace
      namespace = Kubeclient::Resource.new(
        kind: 'Namespace',
        metadata: {
          name: @project.slug
        }
      )
      client = @cluster.get_client("", "v1")
      begin
        client.create_namespace(namespace)
      rescue
        client.update_namespace(namespace)
      end
    end

    def ensure_infrastructure
      client = @cluster.get_client("/apis/infrastructure.cluster.x-k8s.io", 'v1alpha1')
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
          kubernetesVersion: Rails.configuration.launchbox[:vcluster][:default_kubernetes_version]
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

    def apply_addon_subscriptions
      @project.addon_subscriptions.each do |sub|
        version = sub.addon.addon_versions.first
        next if version.nil?

        apply_resource(sub, version)
      end
    end

    def apply_resource(sub, version)
      client = @cluster.get_client("/apis/#{version.group}", version.version)
      resource = build_resource(sub, version)
      action = version.claim_name.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                      .downcase

      client.public_send("apply_#{action}", resource, field_manager: 'launchbox')
    end
    
    def ensure_provider_config(api_path, version)
      client = @cluster.get_client(api_path, version)
      resource = Kubeclient::Resource.new({
                                            metadata: {
                                              name: @project.slug
                                            },
                                            spec: {
                                              credentials: {
                                                source: "Secret",
                                                secretRef: {
                                                  namespace: @project.slug,
                                                  name: "vc-#{@project.slug}",
                                                  key: "config"
                                                }
                                              }
                                            }
                                          })
      begin
        client.create_provider_config(resource)
      rescue Kubeclient::HttpError => e
        if e.error_code == 409
          existing = client.get_provider_config @project.slug
          existing.spec = resource.spec
          client.update_provider_config(existing)
        else
          raise
        end
      end
    end

    def build_resource(sub, version)
      Kubeclient::Resource.new(
        kind: version.claim_name,
        apiVersion: "#{version.group}/#{version.version}",
        metadata: {
          name: sub.name,
          namespace: @project.slug
        },
        # TODO: Add spec inputs based on schema and subscription data
        spec: {
          providerConfigRef: @project.slug
        }
      )
    end
    
    def values
      template = File.read(Rails.configuration.launchbox[:vcluster][:template_file])
      ryaml = ERB.new(template)
      b = binding
      b.local_variable_set(:project, @project)
      ryaml.result(b)
    end
  end
end
