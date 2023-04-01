# frozen_string_literal: true

module Projects
  class CreateProjectJob < ApplicationJob
    queue_as :default

    # TODO: Moving forward, vcluster instances should be created
    # using the Project composition. This way the vcluster, as well as
    # the provider configuration, is handled as a bundle
    def perform(*args)
      @project = Project.find(args.first)
      @cluster = Cluster.find(@project.cluster_id)
      @project.update(status: 'provisioning', last_error: nil)
      cert_store = OpenSSL::X509::Store.new
      cert_store.add_cert(OpenSSL::X509::Certificate.new(@cluster.ca_crt))
      @options = {
        auth_options: { bearer_token: @cluster.token },
        ssl_options: {
          cert_store: cert_store,
          verify_ssl: OpenSSL::SSL::VERIFY_PEER
        }
      }

      create_namespace

      resource = Kubeclient::Resource.new
      resource.kind = 'Cluster'
      resource.metadata = {
        name: @project.slug,
        namespace: @project.slug
      }
      resource.spec = {
        vcluster: {
          values: {
            sync: {
              ingresses: {
                enabled: true
              },
              serviceaccounts: {
                enabled: true
              }
            },
            vcluster: {
              extraArgs: [
                "--kube-apiserver-arg=--oidc-username-claim=preferred_username"
              ],
              resources: {
                limits: {
                  cpu: @project.cpu,
                  memory: "#{@project.memory}Mi"
                }
              }
            },
            ingress: {
              enabled: true
            },
            # isolation: {
            #   enabled: true
            # }
            storage: {
              persistence: true,
              size: "#{@project.disk}Gi"
            }
          }
        }
      }

      cluster_client = Kubeclient::Client.new("#{@cluster.host}/apis/core.launchboxhq.io", 'v1alpha1', **@options)
      cluster_client.discover

      begin
        cluster_client.create_cluster(resource)
      rescue Kubeclient::HttpError => e
        if e.error_code == 409
          cluster_client.merge_patch_cluster(@project.slug, resource, @project.slug)
        else
          @project.update(status: 'failed', last_error: e)
          raise e
        end
      end

      @project.update(status: 'provisioned', last_error: nil)
    end

    def create_namespace
      client = Kubeclient::Client.new(@cluster.host, 'v1', **@options)

      begin
        client.create_namespace(Kubeclient::Resource.new({ metadata: { name: @project.slug } }))
      rescue Kubeclient::HttpError => e
        raise e unless e.error_code == 409
        # client.patch_namespace(project.slug, {})
      end
    end

  end
end