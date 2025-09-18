# frozen_string_literal: true

class Api::V1::ErpProductsController < Api::V1::ApplicationController
  before_action :authorize_user!
  include Pagy::Backend

  def create
    unless products_params[:items].is_a?(Array)
      return render json: { "error": 'O atributo item dos produtos deve ser um vetor!' }, status: :bad_request
    end

    products = products_params[:items].map do |attr|
      ErpProduct.new(attr)
    end

    products.each do |product|
      ActiveRecord::Base.transaction do
        record = ErpProduct.find_or_initialize_by(
          cod_pro: product.cod_pro
        )

        record.assign_attributes(
          des_pro: product.des_pro, cpl_pro: product.cpl_pro,
          uni_med: product.uni_med, cod_mod: product.cod_mod,
          cod_rot: product.cod_rot, cod_bar: product.cod_bar,
          des_teo: product.des_teo, cod_cte: product.cod_cte,
          seq_ccp: product.seq_ccp
        )

        record.save!
      rescue ActiveRecord::RecordInvalid => e
        return render json: { 'error': e.message }, status: :internal_server_error
      end
    end
    render json: { 'data': 'Produtos processados com sucesso!' }
  end

  def index
    pagy, products = pagy(ErpProduct.order(created_at: :desc))

    render json: { pagination: pagination(pagy), data: products }
  end

  def fetch_products_by_cod_linha
    cod_linha = params[:cod_linha]

    if cod_linha.blank?
      return render json: { 'error': 'Query parameter cod_linha é obrigatório!' },
                    status: :bad_request
    end

    pagy, products = pagy(ErpProduct
      .joins('JOIN erp_model_generals mg ON erp_products.cod_mod = mg.cod_mod')
      .joins('JOIN erp_model_items mi ON mi.cod_mod = mg.cod_mod')
      .joins('JOIN equipment_lines el ON el.cod_eqp = mi.cod_balanca')
      .where('el.cod_linha = ?', cod_linha))

    render json: { pagination: pagination(pagy), 'data': products }
  end

  private

  def pagination(pagy)
    {
      page: pagy.page,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }
  end

  def products_params
    params.require(:erp_products).permit(
      items: %i[
        cod_pro des_pro cpl_pro uni_med cod_mod
        cod_rot cod_bar des_teo cod_cte seq_ccp
      ]
    )
  end
end
