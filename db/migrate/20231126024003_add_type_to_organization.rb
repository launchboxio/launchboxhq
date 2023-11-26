class AddTypeToOrganization < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :organization_type, :string
  end
end
