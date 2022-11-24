# frozen_string_literal: true

class CreateSpaces < ActiveRecord::Migration[7.0]
  def change
    create_table :spaces do |t|
      t.string :name
      t.string :status
      t.string :slug, index: { unique: true }
      t.belongs_to :cluster
      t.belongs_to :user

      ### Compute Settings
      # Memory: GiB
      # CPU: Number of cores
      # Disk: space in GB
      # GPU: Number of cores
      t.integer :memory, default: 4096
      t.integer :cpu, default: 2
      t.integer :disk, default: 50
      t.integer :gpu, default: 0

      ### Status changes
      t.datetime :last_paused_at
      t.datetime :last_started_at
      t.text :last_error

      t.timestamps
    end
  end
end
