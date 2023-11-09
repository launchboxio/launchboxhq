# frozen_string_literal: true

module Api
  module V1
    class AddonsController < ApiController
      before_action :find_cluster, except: %i[index new create]
      before_action -> { doorkeeper_authorize! :read_addons, :manage_addons }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_addons }, only: %i[create update destroy]

      before_action :find_addon, only: %i[show update delete]
      # Only allow admins unless listing or retrieving addons
      before_action -> { require_admin! }, except: %i[index show]

      def index
        @addons = Addon.all
        render json: { addons: @addons }
      end

      def show
        render json: { addon: @addon }
      end

      def create
        @addon = Addon.new(addon_params)
        if Addons::CreateAddonService.new(@addon).execute
          render json: { addon: @addon }
        else
          render json: { errors: @addon.errors.full_messages }, status: 400
        end
      end

      def update
        @addon.attributes = update_params
        if Addons::UpdateAddonService.new(@addon).execute
          render json: { addon: @addon }
        else
          render json: { errors: @addon.errors.full_messages }, status: 400
        end
      end

      def destroy
        if Addons::DeleteAddonService.new(@addon).execute
          redirect_to admin_addon_path(@addon), notice: 'Addon updated'
        else
          flash[:error] = @addon.errors.full_messages.to_sentence
          render 'edit'
        end
      end

      private

      def find_addon
        @addon = Addon.find(params[:id])
      end

      def find_cluster
        @addon = Addon.find(params[:id])
      end

      def addon_params
        params.require(:addon).permit(:oci_registry, :oci_version, :name, :pull_policy, :activation_policy)
      end

      def update_params
        params.require(:addon).permit(:oci_registry, :oci_version, :pull_policy, :activation_policy)
      end
    end
  end
end
