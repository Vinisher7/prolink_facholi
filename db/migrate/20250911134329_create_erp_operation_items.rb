class CreateErpOperationItems < ActiveRecord::Migration[7.2]
  def change
    create_table :erp_operation_items do |t|
      t.string :cod_rot
      t.integer :seq_rot
      t.float :tmp_fix
      t.float :tmp_prp
      t.string :cod_cre

      t.timestamps
    end
  end
end
