require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT[:metadata] = %i[page pages count prev next]
Pagy::DEFAULT[:limit] = 10
