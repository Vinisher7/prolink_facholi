class ErpStopGroup < ApplicationRecord
  validates :cod_gru, :des_gru, :abr_gru, presence: true

  validates :cod_gru, length: { maximum: 50 }
  validates :des_gru, length: { maximum: 30 }
  validates :abr_gru, length: { maximum: 3 }
end
