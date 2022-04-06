module Prices
  class Full < EventPrice
    validates :per_person, presence: true, numericality: { greater_than: 0 }

    def full?
      true
    end
  end
end
