# frozen_string_literal: true

class CreateClusters < ActiveRecord::Migration[7.0]
  def change
    create_table :clusters do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :slug, index: { unique: true }
      t.string :region
      t.string :version
      t.string :provider
      t.string :status

      t.belongs_to :oauth_application
      t.belongs_to :user, optional: true

      t.timestamps
    end
  end
end
