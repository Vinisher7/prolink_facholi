class ContingenciaProdutosController < ApplicationController
  before_action :authenticate_user!

  def index
    @contingencia_produtos = ContingenciaProduct.order(created_at: :desc)
    
    respond_to do |format|
      format.html # renderiza a view index
      format.json { render json: @contingencia_produtos }
    end
  end

  def show
    @contingencia_produto = ContingenciaProduct.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render json: @contingencia_produto }
    end
  end

  def new
    @contingencia_produto = ContingenciaProduct.new
    @unity_measurements = ErpUnityMeasurement.order(:uni_med)
  end

  def create
    result = ContingenciaProdutoService::CreateContingenciaProduto.call(
      produto_params: contingencia_produto_params
    )

    if result.success?
      respond_to do |format|
        format.html { redirect_to contingencia_produtos_path, notice: 'Produto de contingência criado com sucesso!' }
        format.json { render json: { message: 'Produto criado com sucesso!', data: result.produto }, status: :created }
      end
    else
      respond_to do |format|
        format.html { 
          @contingencia_produto = ContingenciaProduct.new(contingencia_produto_params)
          @unity_measurements = ErpUnityMeasurement.order(:uni_med)
          render :new, status: :unprocessable_entity 
        }
        format.json { render json: { error: result.message }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @contingencia_produto = ContingenciaProduct.find(params[:id])
    @unity_measurements = ErpUnityMeasurement.order(:uni_med)
  end

  def update
    @contingencia_produto = ContingenciaProduct.find(params[:id])
    
    result = ContingenciaProdutoService::UpdateContingenciaProduto.call(
      produto: @contingencia_produto,
      produto_params: contingencia_produto_params
    )

    if result.success?
      respond_to do |format|
        format.html { redirect_to contingencia_produtos_path, notice: 'Produto atualizado com sucesso!' }
        format.json { render json: { message: 'Produto atualizado com sucesso!', data: result.produto }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { 
          @unity_measurements = ErpUnityMeasurement.order(:uni_med)
          render :edit, status: :unprocessable_entity 
        }
        format.json { render json: { error: result.message }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contingencia_produto = ContingenciaProduct.find(params[:id])
    
    result = ContingenciaProdutoService::DeleteContingenciaProduto.call(
      produto: @contingencia_produto
    )

    if result.success?
      respond_to do |format|
        format.html { redirect_to contingencia_produtos_path, notice: 'Produto removido com sucesso!' }
        format.json { render json: { message: 'Produto removido com sucesso!' }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to contingencia_produtos_path, alert: result.message }
        format.json { render json: { error: result.message }, status: :unprocessable_entity }
      end
    end
  end

  # Endpoint para buscar unidades de medida (AJAX)
  def fetch_unity_measurements
    @unity_measurements = ErpUnityMeasurement.order(:uni_med)
    render json: @unity_measurements, status: :ok
  end

  private

  def contingencia_produto_params
    params.require(:contingencia_product).permit(
      :cod_pro, :des_pro, :uni_med
    )
  end
end