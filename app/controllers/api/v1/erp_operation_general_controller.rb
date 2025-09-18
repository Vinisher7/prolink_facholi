class Api::V1::ErpOperationGeneralController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend

  def create
    unless operation_general_params[:items].is_a?(Array)
      return render json: { 'error': 'O atributo items do Roteiro Geral deve ser um vetor!' }, status: :bad_request
    end

    operation_general = operation_general_params[:items].map do |operation_general_attr|
      ErpOperationGeneral.new(operation_general_attr)
    end

    operation_general.each do |operation_general_attr|
      ActiveRecord::Base.transaction do
        record = ErpOperationGeneral.find_or_initialize_by(
          cod_rot: operation_general_attr.cod_rot,
          ver_rot: operation_general_attr.ver_rot
        )

        record.assign_attributes(
          des_rot: operation_general_attr.des_rot,
          qtd_base: operation_general_attr.qtd_base,
          lot_tec: operation_general_attr.lot_tec
        )

        record.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end
    render json: { 'data': 'Roteiros Gerais processados com sucesso!' }, status: :ok
  end

  def index
    pagy, operation_general = pagy(ErpOperationGeneral.order(created_at: :desc))
    pagination = {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }
    render json: { pagination: pagination, data: operation_general }
  end

  private

  def operation_general_params
    params.require(:erp_roteiro_geral).permit(
      items: %i[cod_rot ver_rot des_rot qtd_base lot_tec]
    )
  end
end
