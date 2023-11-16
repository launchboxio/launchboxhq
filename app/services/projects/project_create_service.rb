# frozen_string_literal: true

module Projects
  class ProjectCreateService < ProjectService
    def execute
      @project.cluster = Cluster.where(status: 'active').sample if @project.cluster.nil?
      return false unless @project.save!

      broadcast('projects.created')
      true
    end
  end
end
