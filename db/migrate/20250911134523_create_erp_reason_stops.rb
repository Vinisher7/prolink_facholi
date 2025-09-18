class CreateErpReasonStops < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_reason_stops do |t|
      t.string :cod_gru
      t.string :cod_mtv
      t.string :des_mtv
      t.string :abr_mtv
      t.boolean :par_lin
      t.integer :tip_par
      t.boolean :sit_mtv

      t.timestamps
    end
  end
end
