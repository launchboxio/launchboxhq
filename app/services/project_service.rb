# frozen_string_literal: true

class ProjectService
  attr_reader :project

  def initialize(project)
    @project = project
    super()
  end

  def build
    data = @project.as_json
    data['users'] = [
      { email: @project.user.email, clusterRole: 'cluster-admin' }
    ]
    data
  end
end
