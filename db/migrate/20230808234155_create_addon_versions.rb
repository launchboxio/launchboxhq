class CreateAddonVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :addon_versions do |t|
      t.belongs_to :addon
      t.string :version
      t.string :claim_name
      t.boolean :default
      t.string :group
      # We no longer need the json_schema field(s)
      # The OpenAPI schema contains it as a property
      t.json :schema

      t.timestamps
    end
  end
end
