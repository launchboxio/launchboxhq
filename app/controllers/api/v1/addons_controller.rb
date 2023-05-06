module Api
  module V1
    class AddonsController < ApiController
      before_action :find_cluster, except: %i[index new create]
      before_action -> { doorkeeper_authorize! :read_addons, :manage_addons }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_addons }, only: %i[create update destroy]
      def index
        @addons = Addon.all
        render json: @addons
      end

      def show
        render json: @addon
      end

      def create;
        @addon = Addon.new(addon_params)
        @addon.save!
        render :json => @addon
      end

      def update
        @addon = Addon.find(params[:id])
        @addon.attributes = addon_params
        @addon.save!
        render :json => @addon
      end

      def destroy
        @addon = Addon.find(params[:id])
        @addon.destroy!
      end

      private

      def find_cluster
        @addon = Addon.find(params[:id])
      end

      def addon_params
        params.require(:addon).permit(:oci_registry, :oci_version, :name)
      end
    end
  end
end
