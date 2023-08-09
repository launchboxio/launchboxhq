class CreateAddonVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :addon_versions do |t|
      t.belongs_to :addon
      t.string :version
      t.string :claim_name
      t.boolean :default
      t.string :group
      t.json :schema

      t.timestamps
    end
  end
end
