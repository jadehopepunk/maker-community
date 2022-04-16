module Forms
  class BookingOrder
    include ActiveModel::Model

    attr_accessor :email, :name, :user, :price_orders
    attr_reader :event_session

    validates :email, presence: true, unless: :user

    delegate :prices, to: :event_session

    def event_session=(session)
      @event_session = session
      set_price_orders if session.present? && price_orders.nil?
    end

    def price_orders_attributes=(prices_attributes)
      prices_attributes.values.each do |price_attributes|
        price_order = price_orders.find { |po| po.price_id.to_s == price_attributes[:price_id] }
        price_order.attributes = price_attributes.except(:price_id)
      end
    end

    private

    def set_price_orders
      @price_orders = prices.map do |price|
        Forms::PriceOrder.new(persons: 0, price:)
      end
    end
  end
end
