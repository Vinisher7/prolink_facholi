module ContingenciaOrdemService
  class AddItemsToOrdem
    include Interactor

    def call
      ordem_id = context.ordem_id
      items = context.items

      # Validações básicas
      return context.fail!(message: 'ID da ordem é obrigatório') if ordem_id.blank?
      return context.fail!(message: 'Lista de itens é obrigatória') if items.blank? || !items.is_a?(Array)

      # Verificar se a ordem existe
      ordem = ContingenciaProductionOrder.find_by(id: ordem_id)
      return context.fail!(message: 'Ordem não encontrada') unless ordem

      # Processar cada item
      created_items = []
      
      ActiveRecord::Base.transaction do
        items.each do |item_data|
          # Validar dados do item
          next if item_data[:cod_pro].blank? || item_data[:qtd].blank?

          # Verificar se o produto existe
          product = ErpProduct.find_by(cod_pro: item_data[:cod_pro]) || 
                    ContingenciaProduct.find_by(cod_pro: item_data[:cod_pro])
          
          unless product
            context.fail!(message: "Produto #{item_data[:cod_pro]} não encontrado")
            raise ActiveRecord::Rollback
          end

          # Criar o item
          item = ContingenciaModelItem.new(
            contingencia_production_order: ordem,
            cod_pro: item_data[:cod_pro],
            qtd: item_data[:qtd].to_f,
            des_pro: product.des_pro,
            uni_med: product.uni_med
          )

          if item.save
            created_items << item
          else
            context.fail!(message: "Erro ao criar item: #{item.errors.full_messages.join(', ')}")
            raise ActiveRecord::Rollback
          end
        end
      end

      context.items = created_items
      context.message = "#{created_items.count} itens adicionados com sucesso à ordem!"
    end
  end
end