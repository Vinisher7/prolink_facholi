class AddColumnNumOrpToContingenciaModelItems < ActiveRecord::Migration[7.2]
  def change
    add_column :contingencia_model_items, :num_orp, :integer
  end
end
