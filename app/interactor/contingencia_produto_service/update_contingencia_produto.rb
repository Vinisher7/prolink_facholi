module ContingenciaProdutoService
  class UpdateContingenciaProduto
    include Interactor

    def call
      produto = context.produto
      produto_params = context.produto_params

      # Validações básicas
      return context.fail!(message: 'Produto é obrigatório') if produto.blank?
      return context.fail!(message: 'Parâmetros do produto são obrigatórios') if produto_params.blank?

      # Validar campos obrigatórios se fornecidos
      if produto_params[:cod_pro].present?
        # Verificar se já existe outro produto com o mesmo código
        existing_erp_product = ErpProduct.find_by(cod_pro: produto_params[:cod_pro])
        existing_contingencia_product = ContingenciaProduct.where.not(id: produto.id).find_by(cod_pro: produto_params[:cod_pro])

        if existing_erp_product || existing_contingencia_product
          return context.fail!(message: 'Já existe outro produto com este código')
        end
      end

      if produto_params[:uni_med].present?
        # Verificar se a unidade de medida existe
        unity_measurement = ErpUnityMeasurement.find_by(uni_med: produto_params[:uni_med])
        return context.fail!(message: 'Unidade de medida não encontrada') unless unity_measurement
      end

      # Atualizar o produto
      if produto.update(produto_params)
        context.produto = produto
        context.message = 'Produto de contingência atualizado com sucesso!'
      else
        context.fail!(message: 'Erro ao atualizar produto de contingência', errors: produto.errors.full_messages)
      end
    end
  end
end