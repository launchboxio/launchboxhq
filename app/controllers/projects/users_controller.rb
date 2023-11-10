# frozen_string_literal: true

module Projects
  class UsersController < Projects::ApplicationController
    before_action :find_project

    def new; end

    def create
      @user = User.find_by!(email: params[:email])
      @project.users << @user
      Projects::SyncProjectJob.perform_async(@project.id)
      redirect_to project_path(@project), notice: 'User added to project'
    end

    # rubocop:disable Metrics/AbcSize
    def destroy
      @user = User.find(params[:id])
      redirect_to project_path(@project), notice: 'The owner of a project cant be removed' and return if @project.user.id == @user.id

      @project.users.delete(@project.users.find(@user.id))
      Projects::SyncProjectJob.perform_async(@project.id)
      redirect_to project_path(@project), notice: 'User successfully removed'
    end
    # rubocop:enable Metrics/AbcSize

    private

    def find_project
      @project = Project.where(user_id: current_user).find(params[:project_id])
    end
  end
end
