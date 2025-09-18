class CreateBateladaPassos < ActiveRecord::Migration[7.2]
  def change
    create_table :batelada_passos do |t|
      t.references :batelada, null: false, foreign_key: true
      t.integer :seq
      t.string :cod_eqp
      t.string :cod_pro
      t.float :qtd_prev
      t.float :qtd_real
      t.float :histerese
      t.float :tolerancia
      t.datetime :dat_ini
      t.datetime :dat_fim
      t.string :user

      t.timestamps
    end
  end
end
