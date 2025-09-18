class ErpProductionOrder < ApplicationRecord
  validates :cod_ori, :num_orp, :des_orp, :cod_pro, :cod_mod, :cod_rot, :ver_mod, :ver_rot, :dat_emi, :dat_ent,
            :qtd_prd, :num_pri, :qtd_bat, presence: true

  validates :cod_ori, length: { maximum: 3 }
  validates :des_orp, length: { maximum: 50 }
  validates :cod_pro, length: { maximum: 14 }
  validates :cod_mod, length: { maximum: 14 }
  validates :cod_rot, length: { maximum: 14 }
end
