# frozen_string_literal: true

class RepositoriesController < ApplicationController
  before_action :find_repository, only: %i[show update destroy]

  def index
    @repositories = current_user.repositories
  end

  def show; end

  def new
    @repository = current_user.repositories.build
  end

  def create
    @repository = current_user.repositories.new(repository_params)
    if Repositories::CreateRepositoryService.new(@repository).execute
      flash[:notice] = 'Repository added'
      redirect_to repositories_path(@repository)
    else
      flash[:notice] = @repository.errors.full_messages
      render 'new'
    end
  end

  private

  def find_repository
    @repository = current_user.repositories.find(params[:id])
  end

  def repository_params
    params.require(:repository).permit(:vcs_connection_id, :repository)
  end
end
