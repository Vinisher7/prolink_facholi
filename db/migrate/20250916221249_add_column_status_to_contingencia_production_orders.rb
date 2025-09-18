class AddColumnStatusToContingenciaProductionOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :contingencia_production_orders, :status, :string
  end
end
