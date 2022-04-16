module Forms
  class PriceOrder
    include ActiveModel::Model

    attr_accessor :price
    attr_reader :persons

    validates :persons, presence: true

    delegate :id, to: :price, prefix: 'price'

    def to_key
      price_id
    end

    def persons=(value)
      @persons = value.to_i
    end
  end
end
