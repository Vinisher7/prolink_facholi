class HomeController < ApplicationController
  before_action :set_auth_headers

  def index
    # Página inicial simples - dashboard
  end

  # ===============================================
  # ORDENS DE PRODUÇÃO - FLUXO DE CONTINGÊNCIA
  # ===============================================

  # PASSO 1: Listar Linhas Disponíveis (GET /api/v1/lines)
  def fetch_lines_data
    response = make_api_request('/api/v1/lines', 'GET')
    render json: response
  end

  # PASSO 2: Buscar Produtos por Linha (GET /api/v1/erp_products/fetch_products_by_cod_linha)
  def fetch_products_by_line
    cod_linha = params[:cod_linha]
    return render json: { error: 'Código da linha é obrigatório' }, status: :bad_request if cod_linha.blank?

    response = make_api_request("/api/v1/erp_products/fetch_products_by_cod_linha?cod_linha=#{cod_linha}", 'GET')
    render json: response
  end

  # PASSO 4: Criar Ordem de Produção de Contingência
  def create_contingencia_order
    order_data = {
      contingencia_ordem_prod: {
        num_orp: params[:num_orp],
        cod_linha: params[:cod_linha],
        cod_pro: params[:cod_pro],
        qtd_prd: params[:qtd_prd].to_f,
        qtd_bat: params[:qtd_bat].to_f
      }
    }

    response = make_api_request('/api/v1/contingencia/contingencia_production_orders', 'POST', order_data)
    render json: response
  end

  # PASSO 5: Adicionar Itens à Ordem de Produção
  def add_items_to_order
    items_data = {
      contingencia_itens_ordem_prod: {
        items: params[:items] || []
      }
    }

    response = make_api_request('/api/v1/contingencia/contingencia_model_items', 'POST', items_data)
    render json: response
  end

  # Listar ordens de contingência existentes
  def list_contingencia_orders
    response = make_api_request('/api/v1/contingencia/contingencia_production_orders', 'GET')
    render json: response
  end

  # ===============================================
  # PRODUTOS DE CONTINGÊNCIA
  # ===============================================

  # Criar produto de contingência (PASSO 3 da doc)
  def create_contingencia_product
    product_data = {
      contingencia_produto: {
        cod_pro: params[:cod_pro],
        des_pro: params[:des_pro],
        uni_med: params[:uni_med]
      }
    }

    response = make_api_request('/api/v1/contingencia/contingencia_products', 'POST', product_data)
    render json: response
  end

  # Listar produtos de contingência
  def list_contingencia_products
    response = make_api_request('/api/v1/contingencia/contingencia_products', 'GET')
    render json: response
  end

  # Listar unidades de medida para validação
  def list_unity_measurements
    response = make_api_request('/api/v1/erp_unity_measurements', 'GET')
    render json: response
  end

  private

  def set_auth_headers
    @auth_header = ActionController::HttpAuthentication::Basic.encode_credentials(
      'facholi@facholi.com',
      'adas32fav@#!32421'
    )
  end

  def make_api_request(endpoint, method, data = nil)
    require 'net/http'
    require 'uri'
    require 'json'

    uri = URI("#{request.base_url}#{endpoint}")

    case method.upcase
    when 'GET'
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri)
    when 'POST'
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri)
      request.body = data.to_json if data
      request['Content-Type'] = 'application/json'
    end

    request['Authorization'] = @auth_header

    begin
      response = http.request(request)
      JSON.parse(response.body)
    rescue StandardError => e
      { error: "Erro na requisição: #{e.message}" }
    end
  end
end
