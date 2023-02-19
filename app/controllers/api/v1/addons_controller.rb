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

      def create
        @addon = Addon.new(addon_params)
        @addon.save!
        render json: @addon
      end
      def update; end
      def destroy; end

      private

      def find_cluster
        @addon = Addon.find(params[:id])
      end

      def addon_params
        params.require(:addon).permit(
          :name,
          :cluster_attachable,
          :project_attachable,
          :definition,
          :json_schema,
          :mapping
        )
      end
    end
  end
end
