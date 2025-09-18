class Api::V1::Contingencia::ContingenciaModelItemsController < Api::V1::ApplicationController
  before_action :authorize_user!

  def create
    unless contingenia_model_items_params[:items].is_a?(Array)
      return render json: { error: 'O atributo item dos itens da ordem de produção deve ser um vetor!' },
                    status: :bad_request
    end

    model_items = contingenia_model_items_params[:items].map do |model_item|
      ContingenciaModelItem.new(model_item)
    end

    model_items.each do |model_item|
      ActiveRecord::Base.transaction do
        model_item.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end

    render json: { 'data': 'Itens adicionados com sucesso a ordem de produção!' }, status: :created
  end

  def index; end

  private

  def contingenia_model_items_params
    params.require(:contingencia_itens_ordem_prod).permit(
      items: %i[num_orp cod_cmp seq_mod qtd_uti cod_balanca origem]
    )
  end
end
