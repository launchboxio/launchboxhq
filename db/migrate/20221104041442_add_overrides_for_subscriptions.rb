class AddOverridesForSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :addon_subscriptions, :chart, :string
    add_column :addon_subscriptions, :repo, :string
    add_column :addon_subscriptions, :version, :string
    add_column :addon_subscriptions, :release, :string
    add_column :addon_subscriptions, :namespace, :string
    add_column :addon_subscriptions, :values, :text
    add_column :addon_subscriptions, :values_merge_type, :text
  end
end
