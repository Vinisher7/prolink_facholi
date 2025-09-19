# frozen_string_literal: true

module ErpProducts
  class FetchErpProductsByCodLinhaService
    include Interactor
    include Pagy::Backend

    def call
      cod_linha = context.cod_linha

      return context.fail!(message: 'Query param cod_linha é obrigatório!') if cod_linha.blank?

      pagy, products = pagy(ErpProduct
      .joins('JOIN erp_model_generals mg ON erp_products.cod_mod = mg.cod_mod')
      .joins('JOIN erp_model_items mi ON mi.cod_mod = mg.cod_mod')
      .joins('JOIN equipment_lines el ON el.cod_eqp = mi.cod_balanca')
      .where('el.cod_linha = ?', cod_linha))

      pagination = PaginationFomatter::PaginationFormatterService.call(
        pagy: pagy
      )

      context.response = { pagination: pagination, products: products }
    end
  end
end
