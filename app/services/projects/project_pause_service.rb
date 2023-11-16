# frozen_string_literal: true

module Projects
  class ProjectPauseService < ProjectService
    def execute
      return false unless @project.update(status: :pausing)

      broadcast('projects.paused')
      true
    end
  end
end
