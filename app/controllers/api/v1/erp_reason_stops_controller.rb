class Api::V1::ErpReasonStopsController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend
  def create
    unless reason_stop_params[:items].is_a?(Array)
      return render json: { 'error': 'O atributo items dos Motivos de Parada deve ser um vetor!' },
                    status: :bad_request
    end

    Rails.logger.info(reason_stop_params[:items])

    reason_stops = reason_stop_params[:items].map do |reason_stop|
      ErpReasonStop.new(reason_stop)
    end

    reason_stops.each do |reason_stop|
      ActiveRecord::Base.transaction do
        record = ErpReasonStop.find_or_initialize_by(
          cod_gru: reason_stop.cod_gru,
          cod_mtv: reason_stop.cod_mtv
        )

        record.assign_attributes(
          des_mtv: reason_stop.des_mtv,
          abr_mtv: reason_stop.abr_mtv,
          par_lin: reason_stop.par_lin,
          tip_par: reason_stop.tip_par,
          sit_mtv: reason_stop.sit_mtv
        )

        record.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end
    render json: { 'data': 'Motivos de Parada processados com sucesso!' }
  end

  def index
    response = PaginationFormatter::PaginationFormatterService.call(
      page: params[:page],
      entity: ErpReasonStop.order(created_at: :desc)
    )

    return render json: { error: response.table[:message] }, status: :bad_request unless response.success?

    render json: { pagination: response.response[:pagination], data: response.response[:entity_data] }
  end

  private

  def reason_stop_params
    params.require(:erp_motivos_parada).permit(
      items: %i[cod_gru cod_mtv des_mtv abr_mtv par_lin tip_par sit_mtv]
    )
  end
end
