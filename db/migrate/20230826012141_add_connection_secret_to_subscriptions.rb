class AddConnectionSecretToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :addon_subscriptions,
               :connection_secret_encrypted,
               :string
  end
end
