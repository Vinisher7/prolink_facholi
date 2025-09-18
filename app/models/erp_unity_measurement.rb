class ErpUnityMeasurement < ApplicationRecord
  validates :uni_med, :des_med, presence: true

  validates :uni_med, length: { maximum: 14 }
  validates :des_med, length: { maximum: 100 }
end
