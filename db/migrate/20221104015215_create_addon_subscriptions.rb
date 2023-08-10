# frozen_string_literal: true

class CreateAddonSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :addon_subscriptions do |t|
      t.belongs_to :project
      t.belongs_to :addon

      t.json :overrides
      t.json :mappings
      t.string :name

      t.timestamps
    end
  end
end
