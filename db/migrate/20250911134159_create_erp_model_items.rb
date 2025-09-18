class CreateErpModelItems < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_model_items do |t|
      t.string :cod_mod
      t.integer :ver_mod
      t.integer :seq_mod
      t.string :cod_cmp
      t.float :qtd_uti
      t.integer :cod_balanca

      t.timestamps
    end
  end
end
