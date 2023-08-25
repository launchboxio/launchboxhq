class CreateResourceDeployments < ActiveRecord::Migration[7.0]
  def change
    create_table :resource_deployments do |t|
      t.belongs_to :project
      t.belongs_to :resource

      t.string :name
      t.string :namespace

      t.string :ref
      t.timestamps
    end
  end
end
