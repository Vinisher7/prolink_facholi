class ErpOperationGeneral < ApplicationRecord
  validates :cod_rot, :ver_rot, :des_rot, :qtd_base, :lot_tec, presence: true

  validates :cod_rot, length: { maximum: 14 }
  validates :des_rot, length: { maximum: 100 }
end
