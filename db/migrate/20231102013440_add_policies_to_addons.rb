class AddPoliciesToAddons < ActiveRecord::Migration[7.0]
  def change
    add_column :addons, :activation_policy, :string
    add_column :addons, :pull_policy, :string
  end
end
