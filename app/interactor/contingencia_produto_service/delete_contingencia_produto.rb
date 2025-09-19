module ContingenciaProdutoService
  class DeleteContingenciaProduto
    include Interactor

    def call
      produto = context.produto

      # Validação básica
      return context.fail!(message: 'Produto é obrigatório') if produto.blank?

      # Verificar se o produto está sendo usado em alguma ordem de contingência
      items_using_product = ContingenciaModelItem.where(cod_pro: produto.cod_pro)
      
      if items_using_product.exists?
        return context.fail!(message: 'Não é possível excluir o produto pois ele está sendo usado em ordens de contingência')
      end

      # Deletar o produto
      if produto.destroy
        context.message = 'Produto de contingência removido com sucesso!'
      else
        context.fail!(message: 'Erro ao remover produto de contingência', errors: produto.errors.full_messages)
      end
    end
  end
end