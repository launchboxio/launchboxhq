# frozen_string_literal: true

module Projects
  class ProjectResumeService < ProjectService
    def execute
      return false unless @project.update(status: :starting)

      Projects::ResumeProjectJob.perform_async(@project.id)
      true
    end
  end
end
