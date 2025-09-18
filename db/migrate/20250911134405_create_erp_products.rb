class CreateErpProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_products do |t|
      t.string :cod_pro
      t.string :des_pro
      t.string :cpl_pro
      t.string :uni_med
      t.string :cod_mod
      t.string :cod_rot
      t.string :cod_bar
      t.string :des_teo
      t.string :cod_cte
      t.integer :seq_ccp

      t.timestamps
    end
  end
end
