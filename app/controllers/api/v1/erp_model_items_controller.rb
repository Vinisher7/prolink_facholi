class Api::V1::ErpModelItemsController < Api::V1::ApplicationController
  before_action :authorize_user!
  
  def create
    unless model_items_params[:items].is_a?(Array)
      return render json: { 'error': 'O atributo items dos Itens de Modelo deve ser um vetor!' }, status: :bad_request
    end

    model_items = model_items_params[:items].map do |model_item|
      ErpModelItem.new(model_item)
    end

    model_items.each do |model_item|
      ActiveRecord::Base.transaction do
        record = ErpModelItem.find_or_initialize_by(
          cod_mod: model_item.cod_mod,
          ver_mod: model_item.ver_mod,
          seq_mod: model_item.seq_mod,
          cod_cmp: model_item.cod_cmp
        )

        record.assign_attributes(
          qtd_uti: model_item.qtd_uti,
          cod_balanca: model_item.cod_balanca
        )

        record.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end
    render json: { 'data': 'Itens do Modelo processados com sucesso!' }, status: :ok
  end

  def index
    response = PaginationFormatter::PaginationFormatterService.call(
      entity: ErpModelItem.order(created_at: :desc),
      page: params[:page]
    )
    
    return render json: { error: response.table[:message] }, status: :bad_request unless response.success?
    
    render json: { pagination: response.response[:pagination], data: response.response[:entity_data] }
  end

  private

  def model_items_params
    params.require(:erp_modelo_itens).permit(
      items: %i[cod_mod ver_mod seq_mod cod_cmp qtd_uti cod_balanca]
    )
  end
end
