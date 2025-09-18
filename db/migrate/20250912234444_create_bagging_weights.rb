class CreateBaggingWeights < ActiveRecord::Migration[7.2]
  def change
    create_table :bagging_weights do |t|
      t.datetime :dt_ini
      t.string :ensacadeira
      t.float :peso_saco
      t.string :num_orp
      t.string :temp_ciclo

      t.timestamps
    end
  end
end
