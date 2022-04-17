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

    def build_order_item(event_session)
      return nil if persons == 0

      result = OrderItem.new(product: event_session, name: price.title, quantity: persons,
                             line_subtotal: price.per_person)
      result.calculate_totals
      result
    end
  end
end
