module ContingenciaOrdemService
  class CreateContingenciaOrdem
    include Interactor

    def call
      ordem_params = context.ordem_params

      # Validações básicas
      return context.fail!(message: 'Parâmetros da ordem são obrigatórios') if ordem_params.blank?
      return context.fail!(message: 'Número da ORP é obrigatório') if ordem_params[:num_orp].blank?
      return context.fail!(message: 'Código da linha é obrigatório') if ordem_params[:cod_linha].blank?
      return context.fail!(message: 'Código do produto é obrigatório') if ordem_params[:cod_pro].blank?

      # Verificar se a linha existe
      line = Line.find_by(cod_linha: ordem_params[:cod_linha])
      return context.fail!(message: 'Linha não encontrada') unless line

      # Verificar se o produto existe (ERP ou Contingência)
      product = ErpProduct.find_by(cod_pro: ordem_params[:cod_pro]) || 
                ContingenciaProduct.find_by(cod_pro: ordem_params[:cod_pro])
      return context.fail!(message: 'Produto não encontrado') unless product

      # Verificar se já existe uma ordem com o mesmo número
      existing_order = ContingenciaProductionOrder.find_by(num_orp: ordem_params[:num_orp])
      return context.fail!(message: 'Já existe uma ordem com este número') if existing_order

      # Criar a ordem
      ordem = ContingenciaProductionOrder.new(ordem_params)
      ordem.status = :PENDENTE

      if ordem.save
        context.ordem = ordem
        context.message = 'Ordem de contingência criada com sucesso!'
      else
        context.fail!(message: 'Erro ao criar ordem de contingência', errors: ordem.errors.full_messages)
      end
    end
  end
end