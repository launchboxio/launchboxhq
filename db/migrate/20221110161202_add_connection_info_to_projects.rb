# frozen_string_literal: true

class AddConnectionInfoToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :host, :string
    add_column :projects, :ca_crt_encrypted, :text
    add_column :projects, :token_encrypted, :string
  end
end
