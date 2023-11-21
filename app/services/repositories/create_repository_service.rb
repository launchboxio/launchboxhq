# frozen_string_literal: true

module Repositories
  class CreateRepositoryService < RepositoryService
    def execute
      client = Octokit::Client.new(access_token: @repository.vcs_connection.access_token)
      repo = client.repository(@repository.repository)
      @repository.default_branch = repo.default_branch
      @repository.visibility = repo.visibility
      @repository.language = repo.language

      false unless @repository.save
      true
    end
  end
end
