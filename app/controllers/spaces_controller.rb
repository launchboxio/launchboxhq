# frozen_string_literal: true

class SpacesController < AuthenticatedController
  before_action :add_initial_breadcrumbs
  before_action :find_space, except: %i[index new create]

  include ActionController::Live

  def index
    @spaces = Space.where(user_id: current_user.id)
  end

  def show; end

  def new
    @clusters = Cluster.all
    @addons = Addon.all
    @space = Space.new
  end

  def create
    @space = current_user.spaces.build(space_params)
    @space.cluster = Cluster.find(params[:space][:cluster])

    params[:addons]&.each do |addon, value|
      value == 'on' && (@space.addons << Addon.find(addon))
    end

    if @space.save
      @space.update(status: 'provisioning')
      SyncDeveloperSpaceJob.perform_now(@space.id)
      redirect_to @space
    else
      flash[:alert] = @space.errors.full_messages
      redirect new_space_path
    end
  end

  def update; end

  def pause
    @space.update(status: 'pausing')
    PauseDeveloperSpaceJob.perform_now(@space.id)
  end

  def resume
    @space.update(status: 'starting')
    ResumeDeveloperSpaceJob.perform_now(@space.id)
  end

  def destroy
    @space.destroy
    CleanupUserSpaceJob.perform_now(@space.slug, @space.cluster_id)
    redirect_to spaces_path, notice: 'Space scheduled for deletion'
  end

  def restart; end

  def logs; end

  private

  def find_space
    @space = Space.where(id: params[:id], user_id: current_user.id)
  end

  def space_params
    params.require(:space).permit(:name)
  end

  def add_initial_breadcrumbs
    breadcrumbs.add 'Spaces', spaces_path
  end
end
