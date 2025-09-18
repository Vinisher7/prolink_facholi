class RenameLotRecToLotTecInErpOperationGenerals < ActiveRecord::Migration[7.2]
  def change
    rename_column :erp_operation_generals, :lot_rec, :lot_tec
  end
end
