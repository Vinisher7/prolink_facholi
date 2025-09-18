class Api::V1::Contingencia::ContingenciaProductionOrdersController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend

  def create
    result = ContingenciaProductionOrderService::CreateContingenciaProductionOrder.call(
      production_order: ContingenciaProductionOrder.new(contingencia_production_order_params)
    )
    return render json: { 'error': result.table[:reason] }, status: :unprocessable_entity unless result.success?

    render json: { 'data': 'Ordem de Produção cadastrada com sucesso!' }, status: :created
  end

  def index
    pagy, contingencia_production_orders = pagy(ContingenciaProductionOrder.order(created_at: :desc))

    pagination = {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }
    render json: { pagination: pagination, data: contingencia_production_orders }, status: :ok
  end

  private

  def contingencia_production_order_params
    params.require(:contingencia_ordem_prod).permit(
      :num_orp, :cod_linha, :cod_pro, :qtd_prd, :qtd_bat
    )
  end
end
