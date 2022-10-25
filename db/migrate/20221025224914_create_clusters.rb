class CreateClusters < ActiveRecord::Migration[7.0]
  def change
    create_table :clusters do |t|
      t.string :name
      t.string :region
      t.string :version
      t.string :provider

      t.belongs_to :user, optional: true

      t.timestamps
    end
  end
end
