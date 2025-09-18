class RemoveColumnCodModFromContingenciaModelItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :contingencia_model_items, :cod_mod, :string
  end
end
