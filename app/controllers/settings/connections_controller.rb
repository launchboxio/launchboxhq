# frozen_string_literal: true

module Settings
  class ConnectionsController < Settings::SettingsController
    def index
      @connections = current_user.vcs_connections
    end

    def destroy
      @connection = current_user.vcs_connections.find(params[:id])
      @connection.destroy
      redirect_to connections_path
    end
  end
end
