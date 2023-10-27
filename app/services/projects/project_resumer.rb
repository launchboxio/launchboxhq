module Projects
  class ProjectResumer < ProjectService
    def execute
      return false unless @project.update(status: :starting)

      Projects::ResumeProjectJob.perform_later(@project.id)
      true
    end
  end
end
