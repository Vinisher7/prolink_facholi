class CreateErpProductionOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_production_orders do |t|
      t.string :cod_ori
      t.integer :num_orp
      t.string :des_orp
      t.string :cod_pro
      t.string :cod_mod
      t.string :cod_rot
      t.integer :ver_mod
      t.integer :ver_rot
      t.date :dat_emi
      t.date :dat_ent
      t.float :qtd_prd
      t.integer :num_pri
      t.string :qtd_bat

      t.timestamps
    end
  end
end
