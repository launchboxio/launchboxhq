# frozen_string_literal: true

class ProjectService
  attr_reader :project

  def initialize(project)
    @project = project
    super()
  end

  protected

  def broadcast(event)
    ClusterChannel.broadcast_to(
      @project.cluster,
      {
        type: event,
        id: SecureRandom.hex,
        payload: { id: @project.id }
      }
    )
  end
end
