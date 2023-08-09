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
      if @addon.update(addon_params)
        Addons::InstallAddonJob.perform_async @addon.id
        redirect_to admin_addon_path(@addon), notice: 'Addon updated'
      else
        flash[:error] = @addon.errors.full_messages.to_sentence
        render 'edit'
      end
    end

    def create
      @addon = Addon.new(addon_params)
      if @addon.save
        Addons::InstallAddonJob.perform_async @addon.id
        redirect_to admin_addon_path(@addon), notice: 'Addon created'
      else
        flash[:error] = @addon.errors.full_messages.to_sentence
        render 'new'
      end
    end

    def destroy
      @addon.destroy
      flash[:notice] = 'Addon deleted'
      redirect_to admin_addons_path
    end

    private
    def addon_params
      params.require(:addon).permit(:name, :oci_registry, :oci_version, :json_schema, :pull_policy, :activation_policy, :template)
    end
  end
end