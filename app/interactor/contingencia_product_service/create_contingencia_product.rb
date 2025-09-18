module ContingenciaProductService
  class CreateContingenciaProduct
    include Interactor

    def call
      product = context.product

      return context.message = 'Produto salvo com sucesso!' if product.save

      context.fail!(message: 'Falha na criação do produto!', reason: product.errors.full_messages)
    end
  end
end
