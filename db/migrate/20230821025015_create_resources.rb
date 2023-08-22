class CreateResources < ActiveRecord::Migration[7.0]
  def change
    create_table :resources do |t|
      t.string :name
      t.belongs_to :vcs_connection
      t.belongs_to :user

      t.string :uses
      t.json :options

      t.string :repository

      t.timestamps
    end
  end
end
