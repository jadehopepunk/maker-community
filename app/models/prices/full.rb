module Prices
  class Full < EventPrice
    validates :per_person, presence: true, numericality: { greater_than: 0 }

    def full?
      true
    end

    def title
      'Full price'
    end
  end
end
