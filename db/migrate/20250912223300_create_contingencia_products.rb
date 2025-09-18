class CreateContingenciaProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :contingencia_products do |t|
      t.string :cod_pro
      t.string :des_pro
      t.string :uni_med

      t.timestamps
    end
  end
end
