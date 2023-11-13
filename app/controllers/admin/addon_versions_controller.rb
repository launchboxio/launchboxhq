# frozen_string_literal: true

module Admin
  class AddonVersionsController < AdminController
    def update
      @addon = Addon.find(params[:addon_id])
      @addon.addon_versions.each do |version|
        version.update(default: version.id == params[:id])
      end
      flash[:info] = 'Default version set for addon'
      redirect_to admin_addon_url(@addon)
    end

    private

    def update_params
      params.require(:addon_version).permit(:default)
    end
  end
end
