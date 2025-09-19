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
      erp_products = ErpProduct
        .joins('JOIN erp_model_generals mg ON erp_products.cod_mod = mg.cod_mod')
        .joins('JOIN erp_model_items mi ON mi.cod_mod = mg.cod_mod')
        .joins('JOIN equipment_lines el ON el.cod_eqp = mi.cod_balanca')
        .where('el.cod_linha = ?', cod_linha)
        .select('erp_products.id, erp_products.cod_pro, erp_products.des_pro, erp_products.uni_med, erp_products.cod_mod')

      # Buscar produtos de contingência (todos, pois não têm relação direta com linha)
      contingencia_products = ContingenciaProduct
        .select('contingencia_products.id, contingencia_products.cod_pro, contingencia_products.des_pro, contingencia_products.uni_med')

      # Combinar os resultados manualmente
      all_products = []
      
      # Adicionar produtos ERP
      erp_products.each do |product|
        all_products << {
          id: product.id,
          cod_pro: product.cod_pro,
          des_pro: product.des_pro,
          uni_med: product.uni_med,
          cod_mod: product.cod_mod,
          source_type: 'ERP'
        }
      end
      
      # Adicionar produtos de contingência
      contingencia_products.each do |product|
        all_products << {
          id: product.id,
          cod_pro: product.cod_pro,
          des_pro: product.des_pro,
          uni_med: product.uni_med,
          cod_mod: nil,
          source_type: 'CONTINGENCIA'
        }
      end

      # Aplicar paginação manual
      page_size = 10
      total_count = all_products.size
      start_index = (page - 1) * page_size
      end_index = start_index + page_size - 1
      paginated_products = all_products[start_index..end_index] || []

      context.response = {
        pagination: {
          current_page: page,
          total_pages: (total_count.to_f / page_size).ceil,
          total_count: total_count,
          per_page: page_size
        },
        products: paginated_products,
        line_info: {
          cod_linha: line.cod_linha,
          des_linha: line.des_linha
        }
      }
    end
  end
end