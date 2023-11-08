# frozen_string_literal: true

class CreateAddons < ActiveRecord::Migration[7.0]
  def change
    create_table :addons do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :oci_registry, null: false
      t.string :oci_version, null: false
      t.string :pull_policy
      t.string :activation_policy
      t.string :status

      t.timestamps
    end
  end
end
