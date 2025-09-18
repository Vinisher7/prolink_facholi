class ErpShift < ApplicationRecord
  validates :cod_turno, :des_turno, :hora_ini, :hora_fim, :dia, :tipo, presence: true

  validates :cod_turno, length: { maximum: 10 }
  validates :des_turno, length: { maximum: 30 }
  validates :dia, length: { maximum: 15 }
  validates :tipo, length: { maximum: 10 }
end
