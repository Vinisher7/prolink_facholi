class ContingenciaProduct < ApplicationRecord
  validate :uom_exists
  validates :cod_pro, :uni_med, presence: true
  validates :cod_pro, uniqueness: true

  private

  def uom_exists
    return if ErpUnityMeasurement.exists?(uni_med: uni_med)

    errors.add(:base, 'Unidade de Medida não encontrada!')
  end
end
