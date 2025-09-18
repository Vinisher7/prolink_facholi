class CreateErpShifts < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_shifts do |t|
      t.string :cod_turno
      t.string :des_turno
      t.datetime :hora_ini
      t.datetime :hora_fim
      t.string :dia
      t.string :tipo

      t.timestamps
    end
  end
end
