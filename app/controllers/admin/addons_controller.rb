# frozen_string_literal: true

module Admin
  class AddonsController < AdminController
    def index
      @addons = Addon.all
    end

    def show
      @addon = Addon.find(params[:id])
    end

    def edit
      @addon = Addon.find(params[:id])
    end

    def new
      @addon = Addon.new
    end

    def update
      @addon = Addon.find(params[:id])
      if Addons::UpdateAddonService.new(@addon).execute
        redirect_to admin_addon_path(@addon), notice: 'Addon updated'
      else
        flash[:error] = @addon.errors.full_messages.to_sentence
        render 'edit'
      end
    end

    def create
      @addon = Addon.new(addon_params)
      if Addons::UpdateAddonService.new(@addon).execute
        redirect_to admin_addon_path(@addon), notice: 'Addon created'
      else
        flash[:error] = @addon.errors.full_messages.to_sentence
        render 'new'
      end
    end

    def destroy
      flash[:notice] = if Addons::DeleteAddonService.new(@addon).execute
                         'Addon deleted'
                       else
                         'There was an error deleting the addon'
                       end
      redirect_to admin_addons_path
    end

    private

    def addon_params
      params.require(:addon).permit(:name, :oci_registry, :oci_version, :pull_policy, :activation_policy, :template)
    end
  end
end
