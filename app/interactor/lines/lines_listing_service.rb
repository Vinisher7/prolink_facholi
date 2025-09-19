module Lines
    class LinesListingService
        include Interactor

        def call
           return Line.all 
        end
    end
end