class CreateAddonSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :addon_subscriptions do |t|
      t.belongs_to :space
      t.belongs_to :addon

      t.timestamps
    end
  end
end
