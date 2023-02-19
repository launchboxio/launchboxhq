# frozen_string_literal: true

class CreateAddonSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :addon_subscriptions do |t|
      t.belongs_to :project, null: true
      t.belongs_to :cluster, null: true
      t.belongs_to :addon

      # Allow overriding addons when adding to cluster
      t.string :version
      t.string :namespace
      t.string :values
      t.string :values_merge_type

      t.timestamps
    end
  end
end
