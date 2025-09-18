class Api::V1::ErpProductionOrdersController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend
  def create
    unless production_order_params[:items].is_a?(Array)
      return render json: { 'error': 'O atributo items das Ordens de Produção deve ser um vetor!' },
                    status: :bad_request
    end

    production_orders = production_order_params[:items].map do |production_order|
      ErpProductionOrder.new(production_order)
    end

    production_orders.each do |production_order|
      ActiveRecord::Base.transaction do
        record = ErpProductionOrder.find_or_initialize_by(
          num_orp: production_order.num_orp
        )

        record.assign_attributes(
          cod_ori: production_order.cod_ori,
          des_orp: production_order.des_orp,
          cod_pro: production_order.cod_pro,
          cod_mod: production_order.cod_mod,
          cod_rot: production_order.cod_rot,
          ver_mod: production_order.ver_mod,
          ver_rot: production_order.ver_rot,
          dat_emi: production_order.dat_emi,
          dat_ent: production_order.dat_ent,
          qtd_prd: production_order.qtd_prd,
          num_pri: production_order.num_pri,
          qtd_bat: production_order.qtd_bat
        )

        record.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end
    render json: { 'data': 'Ordens de Produção processadas com sucesso!' }
  end

  def index
    pagy, production_orders = pagy(ErpProductionOrder.order(created_at: :desc))
    pagination = {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }
    render json: { pagination: pagination, data: production_orders }
  end

  private

  def production_order_params
    params.require(:erp_ordem_prod).permit(
      items: %i[cod_ori num_orp des_orp cod_pro cod_mod cod_rot ver_mod ver_rot dat_emi dat_ent qtd_prd num_pri qtd_bat]
    )
  end
end
