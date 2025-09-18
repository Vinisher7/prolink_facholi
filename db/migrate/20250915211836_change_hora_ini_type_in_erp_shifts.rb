class ChangeHoraIniTypeInErpShifts < ActiveRecord::Migration[7.2]
  def change
    change_column :erp_shifts, :hora_ini, :string
  end
end
