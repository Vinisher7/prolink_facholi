class Api::V1::ErpModelGeneralController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend

  def create
    unless model_general_params[:items].is_a?(Array)
      return render json: { 'error': 'O atributo item dos modelos deve ser um vetor!' }, status: :bad_request
    end

    model_general_info = model_general_params[:items].map do |model_general|
      ErpModelGeneral.new(model_general)
    end

    model_general_info.each do |model_general|
      ActiveRecord::Base.transaction do
        record = ErpModelGeneral.find_or_initialize_by(
          cod_mod: model_general.cod_mod,
          ver_mod: model_general.ver_mod
        )

        record.assign_attributes(
          des_mod: model_general.des_mod,
          uni_med: model_general.uni_med,
          dat_ini: model_general.dat_ini,
          dat_fim: model_general.dat_fim,
          qtd_bas: model_general.qtd_bas,
          sit_mod: model_general.sit_mod
        )

        record.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end

    render json: { 'data': 'Dados gerais dos modelos foram processados com sucesso!' }, status: :ok
  end

  def index
    pagy, model_general = pagy(ErpModelGeneral.order(created_at: :desc))
    pagination = {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }
    render json: { pagination: pagination, data: model_general }
  end

  private

  def model_general_params
    params.require(:erp_modelo).permit(
      items: %i[cod_mod ver_mod des_mod uni_med dat_ini dat_fim qtd_bas sit_mod]
    )
  end
end
