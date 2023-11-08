class CreateVcsConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :vcs_connections do |t|
      t.belongs_to :user

      t.string :method, default: "oauth"

      t.string :provider
      t.string :host
      t.string :email
      t.string :uid

      t.string :access_token_encrypted
      t.string :refresh_token_encrypted
      t.timestamp :expiry

      t.timestamps
    end
  end
end
