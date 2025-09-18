class RemoveVerModFromContingenciaModelItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :contingencia_model_items, :ver_mod, :integer
  end
end
