class ProjectChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    @project = current_user.projects.find(params[:project_id])
    reject_subscription if @project.nil?

    stream_for @project
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
