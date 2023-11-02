# frozen_string_literal: true

module Projects
  class ProjectCreateService < ProjectService
    def execute
      return false unless @project.save!

      data = @project.as_json
      data['users'] = [
        { email: @project.user.email, clusterRole: 'cluster-admin' }
      ]

      Rails.configuration.event_store.publish(::ProjectCreated.new(data: ))
      true
    end
  end
end
