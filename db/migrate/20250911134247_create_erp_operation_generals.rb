class CreateErpOperationGenerals < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_operation_generals do |t|
      t.string :cod_rot
      t.integer :ver_rot
      t.string :des_rot
      t.float :qtd_base
      t.float :lot_rec

      t.timestamps
    end
  end
end
