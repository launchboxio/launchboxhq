class AddDomainToClusters < ActiveRecord::Migration[7.0]
  def change
    add_column :clusters, :domain, :string
  end
end
