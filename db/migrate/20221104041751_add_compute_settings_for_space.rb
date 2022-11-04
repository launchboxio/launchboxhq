class AddComputeSettingsForSpace < ActiveRecord::Migration[7.0]
  def change
    add_column :spaces, :memory, :integer
    add_column :spaces, :cpu, :integer
    add_column :spaces, :disk, :integer

  end
end
