# frozen_string_literal: true

module Api
  module V1
    class ClustersController < Api::V1::ApiController
      before_action :find_cluster, except: %i[index new create]
      before_action -> { doorkeeper_authorize! :read_clusters }, only: %i[index show]
      before_action -> { doorkeeper_authorize! :manage_clusters }, only: %i[create update destroy]

      def index
        @clusters = Cluster.all
        render json: @clusters
      end

      def show
        render json: @cluster
      end

      def create; end
      def update; end
      def destroy; end

      private

      def find_cluster
        @cluster = Cluster.find(params[:id])
      end
    end
  end
end
