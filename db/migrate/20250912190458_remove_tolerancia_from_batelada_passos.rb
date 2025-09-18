class RemoveToleranciaFromBateladaPassos < ActiveRecord::Migration[7.2]
  def change
    remove_column :batelada_passos, :tolerancia, :float
  end
end
