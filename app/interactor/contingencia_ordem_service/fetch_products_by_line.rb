module ContingenciaOrdemService
  class FetchProductsByLine
    include Interactor
    include Pagy::Backend

    def call
      cod_linha = context.cod_linha
      page = context.page || 1

      # Validação básica
      return context.fail!(message: 'Código da linha é obrigatório') if cod_linha.blank?

      # Verificar se a linha existe
      line = Line.find_by(cod_linha: cod_linha)
      return context.fail!(message: 'Linha não encontrada') unless line

      # Buscar produtos do ERP relacionados à linha
      erp_products_query = ErpProduct
        .joins('JOIN erp_model_generals mg ON erp_products.cod_mod = mg.cod_mod')
        .joins('JOIN erp_model_items mi ON mi.cod_mod = mg.cod_mod')
        .joins('JOIN equipment_lines el ON el.cod_eqp = mi.cod_balanca')
        .where('el.cod_linha = ?', cod_linha)
        .select('erp_products.*, \'ERP\' as source_type')

      # Buscar produtos de contingência (todos, pois não têm relação direta com linha)
      contingencia_products_query = ContingenciaProduct
        .select('contingencia_products.*, \'CONTINGENCIA\' as source_type')

      # Unir as consultas
      combined_query = erp_products_query.union(contingencia_products_query)

      # Aplicar paginação usando o PaginationFormatter
      pagination_result = PaginationFormatter::PaginationFormatterService.call(
        page: page,
        entity: combined_query
      )

      if pagination_result.success?
        context.response = {
          pagination: pagination_result.response[:pagination],
          products: pagination_result.response[:entity_data],
          line_info: {
            cod_linha: line.cod_linha,
            des_linha: line.des_linha
          }
        }
      else
        context.fail!(message: pagination_result.table[:message])
      end
    end
  end
end