class AddTemplateToAddons < ActiveRecord::Migration[7.0]
  def change
    add_column :addons, :template, :text
  end
end
