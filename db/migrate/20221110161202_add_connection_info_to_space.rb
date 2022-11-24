# frozen_string_literal: true

class AddConnectionInfoToSpace < ActiveRecord::Migration[7.0]
  def change
    add_column :spaces, :host, :string
    add_column :spaces, :ca_crt_encrypted, :text
    add_column :spaces, :token_encrypted, :string
  end
end
