class CreateServiceSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :service_subscriptions do |t|
      t.belongs_to :project
      t.belongs_to :service

      t.string :name
      t.json :overrides
      t.timestamps
    end
  end
end
