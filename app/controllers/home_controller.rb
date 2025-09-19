class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # Página principal do dashboard - apenas renderiza a view
    # As funcionalidades específicas foram movidas para controllers dedicados:
    # - ContingenciaOrdensController para ordens de contingência
    # - ContingenciaProdutosController para produtos de contingência
  end
end
