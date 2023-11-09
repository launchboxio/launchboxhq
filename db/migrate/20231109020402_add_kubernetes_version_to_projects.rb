class AddKubernetesVersionToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :kubernetes_version, :string
  end
end
