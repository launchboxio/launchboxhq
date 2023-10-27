# frozen_string_literal: true

module Projects
  class SyncProjectJob
    include Sidekiq::Job

    # rubocop:disable Metrics/AbcSize
    def perform(project_id)
      @project = Project.find(project_id)
      @cluster = Cluster.find(@project.cluster_id)
      @oidc_client = Doorkeeper::Application.first

      client = @cluster.get_client('core.launchboxhq.io', 'v1alpha1')
      resource = Kubeclient::Resource.new({
                                            metadata: {
                                              name: @project.slug
                                            },
                                            spec: {
                                              slug: @project.slug,
                                              id: @project.id,
                                              kubernetesVersion: '1.25.15',
                                              resources: {
                                                cpu: @project.cpu,
                                                memory: @project.memory,
                                                disk: @project.disk
                                              },
                                              users: [{
                                                email: @project.user.email,
                                                clusterRole: 'cluster-admin'
                                              }],
                                              oidcConfig: {
                                                issuerUrl: 'https://launchboxhq.dev',
                                                clientId: @oidc_client.uid
                                              },
                                              ingressHost: 'api.testing-launchboxhq.default.launchboxhq.dev',
                                              paused: false
                                            }
                                          })
      begin
        client.create_project(resource)
      rescue Kubeclient::HttpError => e
        raise unless e.error_code == 409

        existing = client.get_project @project.slug
        existing.spec = resource.spec
        client.update_project(existing)
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
