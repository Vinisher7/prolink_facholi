class Api::V1::ErpEquipmentsController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend

  def create
    unless equipment_params[:items].is_a?(Array)
      return render json: { 'error': 'O atributo items dos Equipamentos deve ser um vetor!' }, status: :bad_request
    end

    equipments = equipment_params[:items].map do |equipment|
      ErpEquipment.new(equipment)
    end

    equipments.each do |equipment|
      ActiveRecord::Base.transaction do
        record = ErpEquipment.find_or_initialize_by(
          cod_rec: equipment.cod_rec,
          cod_eqp: equipment.cod_eqp
        )

        record.assign_attributes(
          des_cre: equipment.des_cre,
          des_eqp: equipment.des_eqp,
          eqp_pai: equipment.eqp_pai,
          eqp_pri: equipment.eqp_pri
        )

        record.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end
    render json: { 'data': 'Equipamentos processados com sucesso!' }, status: :ok
  end

  def index
    pagy, equipments = pagy(ErpEquipment.order(created_at: :desc))
    pagination = {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }
    render json: { pagination: pagination, data: equipments }
  end

  private

  def equipment_params
    params.require(:erp_equipamento).permit(
      items: %i[cod_rec cod_eqp des_cre des_eqp eqp_pai eqp_pri]
    )
  end
end
