# frozen_string_literal: true

module Projects
  class ProjectSyncService < ProjectService
    def execute
      broadcast('projects.updated')
    end
  end
end
