# frozen_string_literal: true

module Projects
  class ProjectResumeService < ProjectService
    def execute
      return false unless @project.update(status: :starting)

      broadcast('projects.resumed')
      true
    end
  end
end
