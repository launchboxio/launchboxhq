class CreateTerraformStates < ActiveRecord::Migration[7.0]
  def change
    create_table :terraform_states do |t|
      t.belongs_to :project

      t.string :lock_id
      t.string :workspace

      t.text :lock_data
      t.text :data

      t.timestamps
    end
  end
end
