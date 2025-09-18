class ChangeCodBalancaTypeInErpModelItems < ActiveRecord::Migration[7.2]
  def change
    change_column :erp_model_items, :cod_balanca, :string
  end
end
