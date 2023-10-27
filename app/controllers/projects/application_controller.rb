# frozen_string_literal: true

module Projects
  class ApplicationController < AuthenticatedController
    before_action :find_project

    protected

    def find_project
      @project = current_user.projects.find(params[:project_id])
    end
  end
end
