class CreateLineStops < ActiveRecord::Migration[7.2]
  def change
    create_table :line_stops do |t|
      t.string :cod_linha
      t.string :cod_parada
      t.string :desc_parada
      t.datetime :dat_ini
      t.datetime :dat_fim

      t.timestamps
    end
  end
end
