class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|

      t.string :name

      t.string :deployment_strategy, default: 'helm'
      t.json :update_strategy, default: nil

      t.belongs_to :user
      t.belongs_to :repository

      t.timestamps
    end
  end
end
