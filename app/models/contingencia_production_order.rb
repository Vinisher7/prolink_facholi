class ContingenciaProductionOrder < ApplicationRecord
  validates :num_orp, :cod_pro, :cod_linha, :qtd_prd, :qtd_bat, presence: true
  validate :product_exists
  validate :line_exists
  validates :num_orp, uniqueness: true

  enum status: {
    PENDENTE: '0',
    RODANDO: '1',
    FINALIZADA: '2',
    CANCELADA: '3'
  }

  private

  def product_exists
    return if ErpProduct.exists?(cod_pro: cod_pro)

    errors.add(:base, 'Código de produto inexistente!')
  end

  def line_exists
    return if Line.exists?(cod_linha: cod_linha)

    errors.add(:base, 'Código de linha inexistente!')
  end
end
