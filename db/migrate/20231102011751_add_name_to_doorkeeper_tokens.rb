class AddNameToDoorkeeperTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :oauth_access_tokens, :name, :string
  end
end
