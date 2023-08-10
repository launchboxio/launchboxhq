module Addons
  class AnalyzePackageJob
    include Sidekiq::Job

    def perform(addon_id)
      @addon = Addon.find(addon_id)

      uri = URI.parse(@addon.oci_registry)
      repo = uri.path
      url = "https://ghcr.io/token?scope=repository:#{repo}:pull"
      response = HTTParty.get(url)
      token = response['token']

      headers = {
        Authorization: "Bearer #{token}"
      }

      response = HTTParty.get("https://ghcr.io/v2/#{repo}/manifests/#{@addon.oci_version}", headers:)
      data = JSON.parse(response)
      digest = data['layers'][0]['digest']

      file = Tempfile.new('oci')

      File.open(file.path, "w") do |file|
        file.binmode
        HTTParty.get("https://ghcr.io/v2/#{repo}/blobs/#{digest}", headers:, stream_body: true) do |fragment|
          file.write(fragment)
        end
      end

      Gem::Package::TarReader.new(Zlib::GzipReader.open(file.path)).each do |entry|
        next unless entry.full_name == "package.yaml"

        YAML.load_stream(entry.read) do |document|
          next if document.nil?
          next unless document['kind'] == "CompositeResourceDefinition"

          group = document['spec']['group']
          claim_name = document['spec']['claimNames']['kind']
          versions = document['spec']['versions']

          versions.each do |version|
            @version = @addon.addon_versions.find_or_create_by(version: version['name'])
            @version.group = group
            @version.claim_name = claim_name
            @version.schema = version['schema']['openAPIV3Schema']
            @version.save!
          end
        end
      end
    end
  end
end