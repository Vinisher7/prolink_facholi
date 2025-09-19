module ContingenciaOrdemService
  class ListContingenciaOrdens
    include Interactor
    include Pagy::Backend

    def call
      page = context.page || 1

      # Buscar todas as ordens de contingência
      ordens_query = ContingenciaProductionOrder.order(created_at: :desc)

      # Aplicar paginação usando o PaginationFormatter
      pagination_result = PaginationFormatter::PaginationFormatterService.call(
        page: page,
        entity: ordens_query
      )

      if pagination_result.success?
        context.response = {
          pagination: pagination_result.response[:pagination],
          ordens: pagination_result.response[:entity_data]
        }
      else
        context.fail!(message: pagination_result.table[:message])
      end
    end
  end
end