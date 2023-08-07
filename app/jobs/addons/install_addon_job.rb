module Addons
  class InstallAddonJob
    include Sidekiq::Job

    # TODO: Support installing on specific clusters
    def perform(addon_id)
      @addon = Addon.find(addon_id)

      @clusters = Cluster.all

      @clusters.each do |cluster|
        puts "Installing #{@addon.name} in cluster #{cluster.id}"
        client = cluster.get_client("/apis/pkg.crossplane.io", "v1")
        resource = Kubeclient::Resource.new(
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
        begin
          client.create_configuration(resource)
          puts "Configuration created"
        rescue Kubeclient::HttpError => e
          if e.error_code == 409
            existing = client.get_configuration @addon.name
            existing.spec = resource.spec
            client.update_configuration(existing)
            puts "Configuration updated"
          else
            raise
          end
        end

        @addon.update(status: 'provisioned')
      end
    end
  end
end
