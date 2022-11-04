class CreateClusters < ActiveRecord::Migration[7.0]
  def change
    create_table :clusters do |t|
      t.string :name
      t.string :region
      t.string :version
      t.string :provider
      t.string :status
      t.string :host
      t.string :ca_crt_encrypted
      t.string :token_encrypted

      t.belongs_to :user, optional: true

      t.timestamps
    end
  end
end
