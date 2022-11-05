class AddStateToSpace < ActiveRecord::Migration[7.0]
  def change
    add_column :spaces, :last_started_at, :datetime
    add_column :spaces, :last_paused_at, :datetime
    add_column :spaces, :last_error, :text
  end
end
