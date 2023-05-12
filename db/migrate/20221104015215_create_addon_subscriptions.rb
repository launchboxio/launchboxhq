# frozen_string_literal: true

class CreateAddonSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :addon_subscriptions do |t|
      t.belongs_to :project
      t.belongs_to :addon

      # Allow overriding addons when adding to cluster
      t.string :chart
      t.string :repo
      t.string :version
      t.string :release
      t.string :namespace
      t.string :value
      t.string :values_merge_type

      t.json :overrides
      t.json :mapings
      t.string :name

      t.timestamps
    end
  end
end
