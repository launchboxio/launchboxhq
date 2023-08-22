class CreateProjectsResources < ActiveRecord::Migration[7.0]
  def change
    create_table :projects_resources do |t|
      t.belongs_to :project
      t.belongs_to :resource
      t.string :name
      t.string :ref

      t.index [:project_id, :resource_id, :name], unique: true
      t.timestamps
    end
  end
end
