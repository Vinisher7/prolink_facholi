class ContingenciaModelItem < ApplicationRecord
  validates :seq_mod, :cod_cmp, :qtd_uti, :cod_balanca, :origem, :num_orp, presence: true
  validate :balanca_exists

  private

  def balanca_exists
    return if ErpEquipment.exists?(cod_eqp: cod_balanca)

    errors.add(:base, 'Código de balança inválido!')
  end
end
