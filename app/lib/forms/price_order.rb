module Forms
  class PriceOrder
    include ActiveModel::Model

    attr_accessor :persons, :price

    validates :persons, presence: true

    delegate :id, to: :price, prefix: 'price'

    def to_key
      price_id
    end
  end
end
