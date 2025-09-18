class CreateErpModelGenerals < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_model_generals do |t|
      t.string :cod_mod
      t.integer :ver_mod
      t.string :des_mod
      t.string :uni_med
      t.date :dat_ini
      t.date :dat_fim
      t.float :qtd_bas
      t.char :sit_mod

      t.timestamps
    end
  end
end
