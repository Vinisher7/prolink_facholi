class Api::V1::ErpStopGroupsController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend

  def create
    unless stop_group_params[:items].is_a?(Array)
      return render json: { 'error': 'O atributo items dos Grupos de Parada deve ser um vetor!' },
                    status: :bad_request
    end

    stop_groups = stop_group_params[:items].map do |stop_group|
      ErpStopGroup.new(stop_group)
    end

    stop_groups.each do |stop_group|
      ActiveRecord::Base.transaction do
        record = ErpStopGroup.find_or_initialize_by(
          cod_gru: stop_group.cod_gru
        )

        record.assign_attributes(
          des_gru: stop_group.des_gru,
          abr_gru: stop_group.abr_gru
        )

        record.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end
    render json: { 'data': 'Grupos de Parada processados com sucesso!' }, status: :ok
  end

  def index
    pagy, stop_groups = pagy(ErpStopGroup.order(created_at: :desc))
    pagination = {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }
    render json: { pagination: pagination, data: stop_groups }
  end

  private

  def stop_group_params
    params.require(:erp_grupo_parada).permit(
      items: %i[cod_gru des_gru abr_gru]
    )
  end
end
