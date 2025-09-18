class Api::V1::Contingencia::ContingenciaProductsController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend

  def create
    result = ContingenciaProductService::CreateContingenciaProduct.call(
      product: ContingenciaProduct.new(contingencia_product_params)
    )
    return render json: { 'error': result.table[:reason] }, status: :unprocessable_entity unless result.success?

    render json: { 'data': 'Produto cadastrado com sucesso!' }, status: :created
  end

  def index
    pagy, contingencia_products = pagy(ContingenciaProduct.order(created_at: :desc))

    pagination = {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }

    render json: { pagination: pagination, data: contingencia_products }, status: :ok
  end

  private

  def contingencia_product_params
    params.require(:contingencia_produto).permit(
      :cod_pro, :des_pro, :uni_med
    )
  end
end
