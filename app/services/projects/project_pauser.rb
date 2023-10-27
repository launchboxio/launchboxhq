# frozen_string_literal: true

module Projects
  class ProjectPauser < ProjectService
    def execute
      return false unless @project.update(status: :pausing)

      Projects::PauseProjectJob.perform_later(@project.id)
      true
    end
  end
end
