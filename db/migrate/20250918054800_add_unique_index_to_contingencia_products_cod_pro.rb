class AddUniqueIndexToContingenciaProductsCodPro < ActiveRecord::Migration[7.2]
  def change
    add_index :contingencia_products, :cod_pro, unique: true
  end
end
