module ContingenciaProdutoService
  class CreateContingenciaProduto
    include Interactor

    def call
      produto_params = context.produto_params

      # Validações básicas
      return context.fail!(message: 'Parâmetros do produto são obrigatórios') if produto_params.blank?
      return context.fail!(message: 'Código do produto é obrigatório') if produto_params[:cod_pro].blank?
      return context.fail!(message: 'Descrição do produto é obrigatória') if produto_params[:des_pro].blank?
      return context.fail!(message: 'Unidade de medida é obrigatória') if produto_params[:uni_med].blank?

      # Verificar se a unidade de medida existe
      unity_measurement = ErpUnityMeasurement.find_by(uni_med: produto_params[:uni_med])
      return context.fail!(message: 'Unidade de medida não encontrada') unless unity_measurement

      # Verificar se já existe um produto com o mesmo código (ERP ou Contingência)
      existing_erp_product = ErpProduct.find_by(cod_pro: produto_params[:cod_pro])
      existing_contingencia_product = ContingenciaProduct.find_by(cod_pro: produto_params[:cod_pro])

      if existing_erp_product || existing_contingencia_product
        return context.fail!(message: 'Já existe um produto com este código')
      end

      # Criar o produto
      produto = ContingenciaProduct.new(produto_params)

      if produto.save
        context.produto = produto
        context.message = 'Produto de contingência criado com sucesso!'
      else
        context.fail!(message: 'Erro ao criar produto de contingência', errors: produto.errors.full_messages)
      end
    end
  end
end