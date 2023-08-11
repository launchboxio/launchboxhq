module Addons
  class InstallAddonJob
    include Sidekiq::Job

    def perform(addon_id)
      @addon = Addon.find(addon_id)
      install_addon_on_clusters
      update_addon_status('provisioned')
    end

    private

    def install_addon_on_clusters
      Cluster.all.each do |cluster|
        install_addon_on_cluster(cluster)
      end
    end

    def install_addon_on_cluster(cluster)
      client = cluster.get_client("/apis/pkg.crossplane.io", "v1")
      resource = build_configuration_resource

      begin
        client.create_configuration(resource)
      rescue Kubeclient::HttpError => e
        if e.error_code == 409
          update_existing_configuration(client, resource)
        else
          raise
        end
      end
    end

    def build_configuration_resource
      Kubeclient::Resource.new(
        metadata: {
          name: @addon.name
        },
        spec: {
          package: "#{@addon.oci_registry}:#{@addon.oci_version}",
          packagePullPolicy: @addon.pull_policy,
          revisionAcitivationPolicy: @addon.activation_policy,
          revisionHistoryLimit: 5
        }
      )
    end

    def update_existing_configuration(client, resource)
      existing = client.get_configuration(@addon.name)
      existing.spec = resource.spec
      client.update_configuration(existing)
    end

    def update_addon_status(status)
      @addon.update(status: status)
    end
  end
end
