class ErpModelGeneral < ApplicationRecord
  validates :cod_mod, :ver_mod, :des_mod, :uni_med, :dat_ini, :dat_fim, :qtd_bas, :sit_mod, presence: true

  validates :cod_mod, length: { maximum: 14 }
  validates :ver_mod, length: { maximum: 10 }
  validates :des_mod, length: { maximum: 100 }
  validates :uni_med, length: { maximum: 3 }
  validates :sit_mod, length: { maximum: 1 }
end
