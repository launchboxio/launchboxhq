# frozen_string_literal: true

class CreateAddons < ActiveRecord::Migration[7.0]
  def change
    create_table :addons do |t|
      t.string :name
      t.text :json_schema
      t.text :defaults

      t.string :oci_registry
      t.string :oci_version

      t.timestamps
    end
  end
end
