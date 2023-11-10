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
    data['addons'] = @project.addon_subscriptions.map { |sub| build_addon(sub) }
    data
  end

  def build_addon(sub)
    {
      name: sub.addon.name,
      install_name: sub.name || sub.addon.name
    }
  end
end
