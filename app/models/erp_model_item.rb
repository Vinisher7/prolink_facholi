class ErpModelItem < ApplicationRecord
  validates :cod_mod, :ver_mod, :seq_mod, :cod_cmp, :qtd_uti, :cod_balanca, presence: true

  validates :cod_mod, length: { maximum: 14 }
  validates :cod_cmp, length: { maximum: 14 }
end
