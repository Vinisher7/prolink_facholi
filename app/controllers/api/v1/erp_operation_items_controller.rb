class Api::V1::ErpOperationItemsController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend
  def create
    unless operation_items_params[:items].is_a?(Array)
      return render json: { 'error': 'O atributo items dos Itens do Roteiro deve ser um vetor!' }, status: :bad_request
    end

    operation_items = operation_items_params[:items].map do |operation_item|
      ErpOperationItem.new(operation_item)
    end

    operation_items.each do |operation_item|
      ActiveRecord::Base.transaction do
        record = ErpOperationItem.find_or_initialize_by(
          cod_rot: operation_item.cod_rot,
          ver_rot: operation_item.ver_rot,
          seq_rot: operation_item.seq_rot
        )

        record.assign_attributes(
          tmp_fix: operation_item.tmp_fix,
          tmp_prp: operation_item.tmp_prp,
          cod_cre: operation_item.cod_cre
        )

        record.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end
    render json: { 'data': 'Itens do Roteiro processados com sucesso!' }
  end

  def index
    response = PaginationFormatter::PaginationFormatterService.call(
      page: params[:page],
      entity: ErpOperationItem.order(created_at: :desc)
    )

    return render json: { error: response.table[:message] }, status: :bad_request unless response.success?

    render json: { pagination: response.response[:pagination], data: response.response[:entity_data] }
  end

  private

  def operation_items_params
    params.require(:erp_roteiro_itens).permit(
      items: %i[cod_rot ver_rot seq_rot tmp_fix tmp_prp cod_cre]
    )
  end
end
