class CreateProjectsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :projects_users do |t|
      t.belongs_to :user
      t.belongs_to :project

      t.index [:user_id, :project_id], unique: true
      t.timestamps
    end
  end
end

