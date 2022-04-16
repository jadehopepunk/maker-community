module Prices
  class Free < EventPrice
    def per_person
      0
    end
  end
end
