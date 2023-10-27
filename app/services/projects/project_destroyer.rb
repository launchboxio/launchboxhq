# frozen_string_literal: true

module Projects
  class ProjectDestroyer < ProjectService
    # We trigger the delete job for the project resources. Once
    # that job has completed, it will finalize and remove the
    # attached project
    def execute
      Projects::DeleteProjectJob.perform_async(@project.id)
      return false unless @project.update(status: :pending_deletion)

      true
    end
  end
end
