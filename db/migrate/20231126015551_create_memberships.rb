class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.belongs_to :organization
      t.belongs_to :user

      t.string :role

      t.index %w[user_id organization_id], unique: true

      t.timestamps
    end
  end
end
