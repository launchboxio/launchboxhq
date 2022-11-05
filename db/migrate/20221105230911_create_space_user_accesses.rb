class CreateSpaceUserAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :space_user_accesses do |t|
      t.belongs_to :space
      t.belongs_to :user
      t.string     :role
      
      t.timestamps
    end
  end
end
