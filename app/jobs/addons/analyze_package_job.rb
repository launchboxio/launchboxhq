# frozen_string_literal: true

module Addons
  class AnalyzePackageJob
    include Sidekiq::Job

    def perform(addon_id)
      @addon = Addon.find(addon_id)
      uri = URI.parse(@addon.oci_registry)
      @repo = uri.path
      retrieve_and_process_oci_data
    end

    private

    def retrieve_and_process_oci_data
      token = fetch_oci_token
      digest = fetch_digest(token)
      process_tarball(digest, token)
    end

    def fetch_oci_token
      url = "https://ghcr.io/token?scope=repository:#{@repo}:pull"
      response = HTTParty.get(url)
      response['token']
    end

    def fetch_digest(token)
      headers = {
        Authorization: "Bearer #{token}"
      }
      response = HTTParty.get("https://ghcr.io/v2/#{@repo}/manifests/#{@addon.oci_version}", headers:)
      data = JSON.parse(response)
      data['layers'][0]['digest']
    end

    def process_tarball(digest)
      file = download_tarball(digest)

      Gem::Package::TarReader.new(Zlib::GzipReader.open(file.path)).each do |entry|
        next unless entry.full_name == 'package.yaml'

        process_yaml(entry)
      end
    end

    def download_tarball(digest, token)
      headers = {
        Authorization: "Bearer #{token}"
      }
      file = Tempfile.new('oci')
      File.open(file.path, 'w') do |temp_file|
        temp_file.binmode
        HTTParty.get("https://ghcr.io/v2/#{@repo}/blobs/#{digest}", headers:, stream_body: true) do |fragment|
          temp_file.write(fragment)
        end
      end
      File.delete(file.path)
      file
    end

    def process_yaml(entry)
      YAML.load_stream(entry.read) do |document|
        next unless document && document['kind'] == 'CompositeResourceDefinition'

        group = document['spec']['group']
        claim_name = document['spec']['claimNames']['kind']
        versions = document['spec']['versions']

        process_versions(group, claim_name, versions)
      end
    end

    def process_versions(group, claim_name, versions)
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
