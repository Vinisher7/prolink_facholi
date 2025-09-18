class CreateErpStopGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_stop_groups do |t|
      t.string :cod_gru
      t.string :des_gru
      t.string :abr_gru

      t.timestamps
    end
  end
end
