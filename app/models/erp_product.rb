class ErpProduct < ApplicationRecord
  validates :cod_pro, :des_pro, :uni_med, :cod_mod, :cod_rot, :des_teo,
            presence: true

  validates :cod_pro, length: { maximum: 14 }
  validates :des_pro, length: { maximum: 100 }
  validates :cpl_pro, length: { maximum: 50 }
  validates :uni_med, length: { maximum: 3 }
  validates :cod_mod, length: { maximum: 14 }
  validates :cod_rot, length: { maximum: 14 }
  validates :cod_bar, length: { maximum: 30 }
  validates :des_teo, length: { maximum: 50 }
  validates :cod_cte, length: { maximum: 3 }
  validates :seq_ccp, length: { maximum: 10 }

  def fetch_products_with_cod_linha(cod_linha)
    ErpProduct
      .joins('JOIN erp_model_generals mg ON erp_products.cod_mod = mg.cod_mod')
      .joins('JOIN erp_model_items mi ON mi.cod_mod = mg.cod_mod')
      .joins('JOIN equipment_lines el ON el.cod_eqp = mi.cod_balanca')
      .where('el.cod_linha = ?', cod_linha)
  end
end
