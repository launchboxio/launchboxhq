class AddManifestToCluster < ActiveRecord::Migration[7.0]
  def change
    add_column :clusters, :manifest, :text
  end
end
