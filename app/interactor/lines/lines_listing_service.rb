module Lines
  class LinesListingService
    include Interactor

    def call
      lines = Line.order(:cod_linha)
      
      if lines.any?
        context.response = lines.map do |line|
          {
            id: line.id,
            cod_linha: line.cod_linha,
            des_linha: line.des_linha
          }
        end
      else
        context.response = []
      end
    end
  end
end