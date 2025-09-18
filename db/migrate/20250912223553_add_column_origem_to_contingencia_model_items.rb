class AddColumnOrigemToContingenciaModelItems < ActiveRecord::Migration[7.2]
  def change
    add_column :contingencia_model_items, :origem, :string
  end
end
