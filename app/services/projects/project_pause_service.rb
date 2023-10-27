# frozen_string_literal: true

module Projects
  class ProjectPauseService < ProjectService
    def execute
      return false unless @project.update(status: :pausing)

      Projects::PauseProjectJob.perform_async(@project.id)
      true
    end
  end
end
