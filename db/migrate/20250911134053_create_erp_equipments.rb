class CreateErpEquipments < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_equipments do |t|
      t.string :cod_rec
      t.string :cod_eqp
      t.string :des_cre
      t.string :des_eqp
      t.string :eqp_pai
      t.string :eqp_pri

      t.timestamps
    end
  end
end
