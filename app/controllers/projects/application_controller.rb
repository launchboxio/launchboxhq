module Projects
  class ApplicationController < ApplicationController

    private
    def find_project
      return @project if @project

      @project = current_user.projects.find(params[:id])
    end

    def authorize_admin
      current_user.id == @project.user_id
    end
  end
end