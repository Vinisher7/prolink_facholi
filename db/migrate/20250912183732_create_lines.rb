class CreateLines < ActiveRecord::Migration[7.2]
  def change
    create_table :lines do |t|
      t.string :cod_linha
      t.string :des_linha

      t.timestamps
    end
  end
end
