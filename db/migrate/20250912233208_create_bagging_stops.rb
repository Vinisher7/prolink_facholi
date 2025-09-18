class CreateBaggingStops < ActiveRecord::Migration[7.2]
  def change
    create_table :bagging_stops do |t|
      t.datetime :ini_parada
      t.datetime :fim_parada
      t.string :cod_parada
      t.string :desc_parada
      t.string :ensacadeira
      t.string :num_orp

      t.timestamps
    end
  end
end
