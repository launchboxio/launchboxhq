module Projects
  class UsersController < AuthenticatedController
    before_action :find_project

    def create
      @user = User.find_by!(email: params[:email])
      @project.users << @user
      Projects::SyncProjectJob.perform_async(@project.id)
      redirect_to project_path(@project), notice: 'User added to project'
    end

    def destroy
      @user = User.find(params[:id])
      if @project.user.id == @user.id
        redirect_to project_path(@project), notice: 'The owner of a project cant be removed' and return
      end
      @project.users.delete(@project.users.find(@user.id))
      Projects::SyncProjectJob.perform_async(@project.id)
      redirect_to project_path(@project), notice: 'User successfully removed'
    end

    private
    def find_project
      @project = Project.where(user_id: current_user).find(params[:project_id])
    end
  end
end