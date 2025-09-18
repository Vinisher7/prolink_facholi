# frozen_string_literal: true

class Api::V1::ErpUnityMeasurementsController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend
  def create
    unless uom_params[:items].is_a?(Array)
      return render json: { 'error': 'O atributo item das unidades de medida deve ser um vetor!' }, status: :bad_request
    end

    uoms = uom_params[:items].map do |uom|
      ErpUnityMeasurement.new(uom)
    end

    uoms.each do |uom|
      ActiveRecord::Base.transaction do
        record = ErpUnityMeasurement.find_or_initialize_by(
          uni_med: uom.uni_med
        )

        record.assign_attributes(
          des_med: uom.des_med
        )

        record.save!
      end
    end
    render json: { 'data': 'Unidades de medida processadas com sucesso!' }, status: :ok
  end

  def index
    pagy, uoms = pagy(ErpUnityMeasurement.order(created_at: :desc))
    pagination = {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }
    render json: { pagination: pagination, data: uoms }
  end

  private

  def uom_params
    params.require(:erp_uom).permit(
      items: %i[uni_med des_med]
    )
  end
end
