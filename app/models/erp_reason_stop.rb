class ErpReasonStop < ApplicationRecord
  validates :cod_gru, :cod_mtv, :des_mtv, :sit_mtv, presence: true

  validates :cod_gru, length: { maximum: 50 }
  validates :cod_mtv, length: { maximum: 3 }
  validates :des_mtv, length: { maximum: 30 }
end
