# frozen_string_literal: true

class RepositoryService
  attr_reader :repository

  def initialize(repository)
    @repository = repository
    super()
  end
end
