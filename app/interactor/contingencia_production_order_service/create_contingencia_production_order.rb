module ContingenciaProductionOrderService
  class CreateContingenciaProductionOrder
    include Interactor

    def call
      production_order = context.production_order

      production_order.status = :PENDENTE

      return context.message = 'Ordem de Produção criada com sucesso!' if production_order.save

      context.fail!(message: 'Falha na criação da ordem de produção!',
                    reason: production_order.errors.full_messages)
    end
  end
end
