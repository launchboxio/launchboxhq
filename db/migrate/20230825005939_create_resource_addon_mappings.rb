class CreateResourceAddonMappings < ActiveRecord::Migration[7.0]
  def change
    create_table :resource_addon_mappings do |t|
      t.belongs_to :addon_subscription
      t.belongs_to :resource_deployments

      t.string :variable_name

      t.timestamps
    end
  end
end
