class AddColumnCodLinhaToContingenciaProductionOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :contingencia_production_orders, :cod_linha, :string
  end
end
