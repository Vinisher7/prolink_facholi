class CreateEquipmentLines < ActiveRecord::Migration[7.2]
  def change
    create_table :equipment_lines do |t|
      t.string :cod_linha
      t.string :cod_eqp

      t.timestamps
    end
  end
end
