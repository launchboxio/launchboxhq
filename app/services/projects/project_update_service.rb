# frozen_string_literal: true

module Projects
  class ProjectUpdateService < ProjectService
    def execute
      return false unless @project.save!

      broadcast('projects.updated')
      true
    end
  end
end
