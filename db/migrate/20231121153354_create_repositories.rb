class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|

      t.string :repository
      t.string :repository_url
      t.string :default_branch

      t.string :visibility, default: 'public'
      t.string :language, default: nil

      t.string :default_deployment_strategy
      t.string :default_update_strategy

      t.belongs_to :user
      t.belongs_to :vcs_connection

      t.timestamps
    end
  end
end
