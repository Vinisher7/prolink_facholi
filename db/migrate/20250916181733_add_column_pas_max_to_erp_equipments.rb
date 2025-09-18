class AddColumnPasMaxToErpEquipments < ActiveRecord::Migration[7.2]
  def change
    add_column :erp_equipments, :pas_max, :integer
  end
end
