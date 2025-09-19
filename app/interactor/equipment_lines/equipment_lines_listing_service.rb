module EquipmentLines
  class EquipmentLinesListingService
    include Interactor
    include Pagy::Backend

    def call
      cod_linha = context.cod_linha
      page = context.page || 1

      # Validação básica
      return context.fail!(message: 'Código da linha é obrigatório') if cod_linha.blank?

      # Buscar equipamentos da linha específica com informações do ERP
      equipment_lines_query = EquipmentLine
        .joins('JOIN erp_equipments ON equipment_lines.cod_eqp = erp_equipments.cod_eqp')
        .where(cod_linha: cod_linha)
        .select('equipment_lines.*, erp_equipments.pas_max, erp_equipments.des_eqp')
        .order(:cod_eqp)

      # Aplicar paginação usando o PaginationFormatter
      pagination_result = PaginationFormatter::PaginationFormatterService.call(
        page: page,
        entity: equipment_lines_query
      )

      if pagination_result.success?
        context.response = {
          pagination: pagination_result.response[:pagination],
          equipment_lines: pagination_result.response[:entity_data].map do |equipment|
            {
              id: equipment.id,
              cod_linha: equipment.cod_linha,
              cod_eqp: equipment.cod_eqp,
              pas_max: equipment.pas_max,
              des_eqp: equipment.des_eqp
            }
          end,
          line_info: {
            cod_linha: cod_linha
          }
        }
      else
        context.fail!(message: pagination_result.table[:message])
      end
    end
  end
end