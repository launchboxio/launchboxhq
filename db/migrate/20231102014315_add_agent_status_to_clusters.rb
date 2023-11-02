class AddAgentStatusToClusters < ActiveRecord::Migration[7.0]
  def change
    add_column :clusters, :agent_connected, :boolean
    add_column :clusters, :agent_last_ping, :datetime
    add_column :clusters, :agent_identifier, :string
    add_column :clusters, :agent_version, :string
  end
end
