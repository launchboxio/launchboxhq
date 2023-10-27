# frozen_string_literal: true

class ProjectService
  attr_reader :project

  def initialize(project)
    @project = project
    super()
  end
end
