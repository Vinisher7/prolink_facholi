module ErpProducts
  class MateriaPrimaListingService
    include Interactor
    include Pagy::Backend

    def call
      page = context.page || 1
      cod_filter = context.cod_filter
      source = context.source || 'contingencia' # Default para contingência

      if source == 'erp'
        # Buscar produtos ERP onde des_teo = 'Matéria-Prima'
        products_query = ErpProduct.where(des_teo: 'Matéria-Prima').order(:cod_pro)
        
        # Aplicar filtro por código se fornecido
        if cod_filter.present?
          products_query = products_query.where('cod_pro LIKE ?', "%#{cod_filter}%")
        end
        
        # Aplicar paginação usando o PaginationFormatter
        pagination_result = PaginationFormatter::PaginationFormatterService.call(
          page: page,
          entity: products_query
        )

        if pagination_result.success?
          context.response = {
            pagination: pagination_result.response[:pagination],
            materia_prima: pagination_result.response[:entity_data].map do |produto|
              {
                id: produto.id,
                cod_pro: produto.cod_pro,
                des_pro: produto.des_pro,
                uni_med: produto.uni_med,
                des_teo: produto.des_teo,
                source_type: 'ERP'
              }
            end
          }
        else
          context.fail!(message: pagination_result.table[:message])
        end
      else
        # Buscar produtos de contingência
        products_query = ContingenciaProduct.order(:cod_pro)
        
        # Aplicar filtro por código se fornecido
        if cod_filter.present?
          products_query = products_query.where('cod_pro LIKE ?', "%#{cod_filter}%")
        end
        
        # Aplicar paginação usando o PaginationFormatter
        pagination_result = PaginationFormatter::PaginationFormatterService.call(
          page: page,
          entity: products_query
        )

        if pagination_result.success?
          context.response = {
            pagination: pagination_result.response[:pagination],
            materia_prima: pagination_result.response[:entity_data].map do |produto|
              {
                id: produto.id,
                cod_pro: produto.cod_pro,
                des_pro: produto.des_pro,
                uni_med: produto.uni_med,
                des_teo: nil, # Produtos de contingência não têm des_teo
                source_type: 'CONTINGENCIA'
              }
            end
          }
        else
          context.fail!(message: pagination_result.table[:message])
        end
      end
    end
  end
end