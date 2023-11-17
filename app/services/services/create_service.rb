# frozen_string_literal: true

module Services
  class CreateService
    attr_reader :service

    def initialize(service)
      @service = service
    end

    def execute
      # TODO: Don't require a VCS connection
      client = Octokit::Client.new(access_token: @service.vcs_connection.access_token)
      repo = client.repository(@service.full_name)
      @service.default_branch = repo.default_branch
      @service.visibility = repo.visibility
      @service.language = repo.language

      return false unless @service.save

      true
    end
  end
end
