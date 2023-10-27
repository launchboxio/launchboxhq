# frozen_string_literal: true

module Projects
  class ProjectCreator < ProjectService
    def execute
      return false unless @project.save!

      Projects::SyncProjectJob.perform_async(@project.id)
      # Post an update to ActionCable as well
      true
    end
  end
end
