class AddOciConfigurationAddons < ActiveRecord::Migration[7.0]
  def change
    add_column :addons, :oci_registry, :string
    add_column :addons, :oci_version, :string
  end
end
