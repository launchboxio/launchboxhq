# frozen_string_literal: true

class CreateClusterAddonSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :cluster_addon_subscriptions do |t|
      t.belongs_to :cluster
      t.belongs_to :cluster_addon

      t.json :overrides
      t.json :mappings
      t.string :name

      t.timestamps
    end
  end
end
