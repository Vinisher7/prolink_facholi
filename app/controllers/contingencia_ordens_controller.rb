class ContingenciaOrdensController < ApplicationController
  before_action :authenticate_user!

  def index
    @contingencia_ordens = ContingenciaProductionOrder.order(created_at: :desc)
    
    respond_to do |format|
      format.html # renderiza a view index
      format.json { render json: @contingencia_ordens }
    end
  end

  def show
    @contingencia_ordem = ContingenciaProductionOrder.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render json: @contingencia_ordem }
    end
  end

  def new
    @contingencia_ordem = ContingenciaProductionOrder.new
    @lines = Line.order(:cod_linha)
  end

  def create
    result = ContingenciaOrdemService::CreateContingenciaOrdem.call(
      ordem_params: contingencia_ordem_params
    )

    if result.success?
      respond_to do |format|
        format.html { redirect_to contingencia_ordens_path, notice: 'Ordem de contingência criada com sucesso!' }
        format.json { render json: { message: 'Ordem criada com sucesso!', data: result.ordem }, status: :created }
      end
    else
      respond_to do |format|
        format.html { 
          @contingencia_ordem = ContingenciaProductionOrder.new(contingencia_ordem_params)
          @lines = Line.order(:cod_linha)
          render :new, status: :unprocessable_entity 
        }
        format.json { render json: { error: result.message }, status: :unprocessable_entity }
      end
    end
  end

  def add_items
    result = ContingenciaOrdemService::AddItemsToOrdem.call(
      ordem_id: params[:id],
      items: params[:items] || []
    )

    if result.success?
      render json: { message: 'Itens adicionados com sucesso!' }, status: :ok
    else
      render json: { error: result.message }, status: :unprocessable_entity
    end
  end

  # Endpoint para buscar produtos por linha (AJAX)
  def fetch_products_by_line
    cod_linha = params[:cod_linha]
    
    if cod_linha.blank?
      return render json: { error: 'Código da linha é obrigatório' }, status: :bad_request
    end

    result = ContingenciaOrdemService::FetchProductsByLine.call(
      cod_linha: cod_linha,
      page: params[:page]
    )

    if result.success?
      render json: result.response, status: :ok
    else
      render json: { error: result.message }, status: :bad_request
    end
  end

  # Endpoint para buscar linhas (AJAX)
  def fetch_lines
    result = Lines::LinesListingService.call

    if result.success?
      render json: result.response, status: :ok
    else
      render json: { error: result.message }, status: :bad_request
    end
  end

  # Endpoint para buscar equipamentos de uma linha (AJAX)
  def fetch_equipment_lines
    cod_linha = params[:cod_linha]
    
    if cod_linha.blank?
      return render json: { error: 'Código da linha é obrigatório' }, status: :bad_request
    end

    result = EquipmentLines::EquipmentLinesListingService.call(
      cod_linha: cod_linha,
      page: params[:page]
    )

    if result.success?
      render json: result.response, status: :ok
    else
      render json: { error: result.message }, status: :bad_request
    end
  end

  # Endpoint para buscar matérias-primas (AJAX)
  def fetch_materia_prima
    result = ErpProducts::MateriaPrimaListingService.call(
      page: params[:page],
      cod_filter: params[:cod_filter],
      source: params[:source] || 'contingencia'
    )

    if result.success?
      render json: result.response, status: :ok
    else
      render json: { error: result.message }, status: :bad_request
    end
  end

  private

  def contingencia_ordem_params
    params.require(:contingencia_production_order).permit(
      :num_orp, :cod_linha, :cod_pro, :qtd_prd, :qtd_bat
    )
  end
end