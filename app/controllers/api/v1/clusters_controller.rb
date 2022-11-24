# frozen_string_literal: true

module Api
  module V1
    class ClustersController < Api::V1::ApiController
      def index
        @clusters = Cluster.all
        render json: @clusters
      end

      def show; end
    end
  end
end
