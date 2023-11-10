class AddProjectIdNameIndexToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_index :addon_subscriptions, [:project_id, :addon_id, :name], unique: true
  end
end
