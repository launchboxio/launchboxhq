# frozen_string_literal: true

class CreateAddons < ActiveRecord::Migration[7.0]
  def change
    create_table :addons do |t|
      t.string :chart
      t.string :repo
      t.string :version
      t.string :username_encrypted
      t.string :password_encrypted
      t.string :release
      t.string :namespace
      t.text :values

      t.timestamps
    end
  end
end
