class AddInstallStatusToAddonSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :addon_subscriptions, :status, :string
  end
end
