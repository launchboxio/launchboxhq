module Api
  module V1
    class AddonsController < ApiController
      before_action :find_cluster, except: %i[index new create]
      before_action -> { doorkeeper_authorize! :read_addons }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_addons }, only: %i[create update destroy]
      def index
        @addons = Addon.all
        render json: @addons
      end

      def show
        render json: @addon
      end
      def create; end
      def update; end
      def destroy; end

      private

      def find_cluster
        @addon = Addon.find(params[:id])
      end
    end
  end
end
