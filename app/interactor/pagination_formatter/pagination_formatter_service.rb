# frozen_string_literal: true

module PaginationFormatter
  class PaginationFormatterService
    include Interactor
    include Pagy::Backend

    def call
      entity = context.entity
      page = context.page

      return context.fail!(message: 'Query param page é obrigatório!') if page.blank?

      pagy, entity_data = pagy(entity, page: page)
      pagination = {
        page: pagy.page,
        pages: pagy.pages,
        count: pagy.count,
        prev: pagy.prev,
        next: pagy.next
      }

      context.response = { pagination: pagination, entity_data: entity_data }
    end
  end
end
