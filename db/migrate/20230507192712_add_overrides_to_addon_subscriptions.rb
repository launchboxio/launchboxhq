class AddOverridesToAddonSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :addon_subscriptions, :overrides, :json
    add_column :addon_subscriptions, :name, :string
    add_column :addon_subscriptions, :mappings, :json
  end
end
