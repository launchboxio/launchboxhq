# frozen_string_literal: true

class CreateAddons < ActiveRecord::Migration[7.0]
  def change
    create_table :addons do |t|
      t.string :name
      t.boolean :cluster_attachable
      t.boolean :project_attachable
      t.text :definition
      t.text :json_schema
      t.text :mapping

      t.timestamps
    end
  end
end
