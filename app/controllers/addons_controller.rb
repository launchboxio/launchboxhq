class AddonsController < AuthenticatedController
  def index
    @addons = Addon.all
  end

  def show
    @addon = Addon.find(params[:id])
  end

  def new
    @addon = Addon.new
  end

  def create
    @addon = Addon.new(addon_params)
    if @addon.save
      redirect_to @addon
    else
      render "new"
    end
  end

  def edit

  end

  def update

  end

  def delete

  end

  private

  def addon_params
    params.require(:addon).permit(:chart, :repo, :version, :username, :password, :release, :namespace, :values)
  end
end
