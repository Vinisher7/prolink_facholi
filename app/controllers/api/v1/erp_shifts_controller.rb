class Api::V1::ErpShiftsController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend
  def create
    unless shift_params[:items].is_a?(Array)
      return render json: { 'error': 'O atributo item dos modelos deve ser um vetor!' }, status: :bad_request
    end

    shifts = shift_params[:items].map do |shift|
      ErpShift.new(shift)
    end

    shifts.each do |shift|
      ActiveRecord::Base.transaction do
        record = ErpShift.find_or_initialize_by(
          cod_turno: shift.cod_turno
        )

        record.assign_attributes(
          des_turno: shift.des_turno,
          hora_ini: shift.hora_ini,
          hora_fim: shift.hora_fim,
          dia: shift.dia,
          tipo: shift.tipo
        )

        record.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end

    render json: { 'data': 'Turnos processados com sucesso!' }, status: :ok
  end

  def index
    pagy, shifts = pagy(ErpShift.order(created_at: :desc))
    pagination = {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }
    render json: { pagination: pagination, data: shifts }
  end

  private

  def shift_params
    params.require(:erp_turno).permit(
      items: %i[cod_turno des_turno hora_ini hora_fim dia tipo]
    )
  end
end
