class AddColumnVerRotToErpOperationItems < ActiveRecord::Migration[7.2]
  def change
    add_column :erp_operation_items, :ver_rot, :integer
  end
end
