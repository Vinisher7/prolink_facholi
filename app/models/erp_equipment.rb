class ErpEquipment < ApplicationRecord
  validates :cod_rec, :cod_eqp, :des_cre, :des_eqp, presence: true

  validates :cod_rec, length: { maximum: 8 }
  validates :cod_eqp, length: { maximum: 8 }
  validates :des_cre, length: { maximum: 40 }
  validates :des_eqp, length: { maximum: 40 }
  validates :eqp_pai, length: { maximum: 20 }
  validates :eqp_pri, length: { maximum: 20 }
end
