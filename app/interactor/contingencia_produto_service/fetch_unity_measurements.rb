module ContingenciaProdutoService
  class FetchUnityMeasurements
    include Interactor

    def call
      # Buscar todas as unidades de medida ordenadas
      unity_measurements = ErpUnityMeasurement.order(:uni_med)

      context.response = unity_measurements.map do |unity|
        {
          id: unity.id,
          uni_med: unity.uni_med,
          des_uni_med: unity.des_med  # Corrigido: campo correto é des_med
        }
      end
    end
  end
end