# frozen_string_literal: true

class CreateClusters < ActiveRecord::Migration[7.0]
  def change
    create_table :clusters do |t|
      t.string :name
      t.string :slug, index: { unique: true }
      t.string :region
      t.string :version
      t.string :provider
      t.string :status
      t.string :host
      t.string :ca_crt_encrypted
      t.string :token_encrypted
      t.string :connection_method
      t.boolean :managed, default: false

      t.text :manifest

      t.belongs_to :oauth_application
      t.belongs_to :user, optional: true

      t.timestamps
    end
  end
end
