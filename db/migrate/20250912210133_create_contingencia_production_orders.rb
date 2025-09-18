class CreateContingenciaProductionOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :contingencia_production_orders do |t|
      t.integer :num_orp
      t.string :cod_pro
      t.float :qtd_prd
      t.string :qtd_bat

      t.timestamps
    end
  end
end
