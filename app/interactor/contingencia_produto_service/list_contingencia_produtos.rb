module ContingenciaProdutoService
  class ListContingenciaProdutos
    include Interactor
    include Pagy::Backend

    def call
      page = context.page || 1

      # Buscar todos os produtos de contingência
      produtos_query = ContingenciaProduct.order(created_at: :desc)

      # Aplicar paginação usando o PaginationFormatter
      pagination_result = PaginationFormatter::PaginationFormatterService.call(
        page: page,
        entity: produtos_query
      )

      if pagination_result.success?
        context.response = {
          pagination: pagination_result.response[:pagination],
          produtos: pagination_result.response[:entity_data]
        }
      else
        context.fail!(message: pagination_result.table[:message])
      end
    end
  end
end