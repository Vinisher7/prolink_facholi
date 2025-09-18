class CreateBateladas < ActiveRecord::Migration[7.2]
  def change
    create_table :bateladas do |t|
      t.integer :num_orp
      t.integer :dosagem
      t.string :cod_linha
      t.datetime :dat_ini
      t.datetime :data_fim
      t.boolean :is_retrabalho
      t.string :status

      t.timestamps
    end
  end
end
