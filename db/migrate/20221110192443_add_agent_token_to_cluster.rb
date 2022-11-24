# frozen_string_literal: true

class AddAgentTokenToCluster < ActiveRecord::Migration[7.0]
  def change
    add_column :clusters, :agent_token_encrypted, :string, unique: true
  end
end
