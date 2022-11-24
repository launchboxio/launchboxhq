# frozen_string_literal: true

class CreateAgents < ActiveRecord::Migration[7.0]
  def change
    create_table :agents do |t|
      t.belongs_to :cluster
      t.datetime :last_communication
      t.string :status

      t.string :access_token_encrypted
      t.string :refresh_token_encrypted

      t.string :ip_address
      t.string :pod_name
      t.string :node_name

      t.timestamps
    end
  end
end
