class CreateSpaces < ActiveRecord::Migration[7.0]
  def change
    create_table :spaces do |t|
      t.string :name
      t.string :status
      t.string :slug, index: { unique: true }
      t.belongs_to :cluster
      t.belongs_to :user

      t.timestamps
    end
  end
end
