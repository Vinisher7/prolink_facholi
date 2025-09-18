class ChangeHoraFimTypeInErpShifts < ActiveRecord::Migration[7.2]
  def change
    change_column :erp_shifts, :hora_fim, :string
  end
end
