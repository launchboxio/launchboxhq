class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name, index: { unique: true }
      t.string :company
      t.string :email
      t.boolean :is_verified
      t.string :plan
      t.timestamps
    end
  end
end
