module Forms
  class BookingOrder
    include ActiveModel::Model

    attr_accessor :user, :price_orders, :email, :name, :comments
    attr_reader :event_session

    validates :email, presence: true, unless: :user
    validates :name, presence: true, unless: :user
    validates :total_persons, comparison: { greater_than: 0, message: 'You must select at least one person' }
    validates_each :user do |record, attr, value|
      if value && record.event_session.bookings.confirmed.where(user: value).exists?
        record.errors.add(attr,
                          'You already have a booking for this event')
      end
    end

    delegate :prices, to: :event_session

    def event_session=(session)
      @event_session = session
      set_price_orders if session.present? && price_orders.nil?
    end

    def price_orders_attributes=(prices_attributes)
      prices_attributes.each_value do |price_attributes|
        price_order = price_orders.find { |po| po.price_id.to_s == price_attributes[:price_id].to_s }
        unless price_order.present?
          raise ArgumentError,
                "Didn't find price for id #{price_attributes[:price_id].inspect} amongst #{price_orders.inspect}"
        end

        price_order.attributes = price_attributes.except(:price_id)
      end
    end

    def total_persons
      price_orders.map(&:persons).sum
    end

    def save
      raise ArgumentError, 'This needs to be setup with an event session' unless event_session.present?

      if valid?
        save_booking!
        return true
      end

      false
    end

    private

    def save_booking!
      booking = build_booking
      EventBookingsService.new.create(booking).save!
    end

    def build_booking
      EventBooking.new(user:, session: event_session, status: 'complete', persons: total_persons, comments:)
    end

    def set_price_orders
      @price_orders = prices.map do |price|
        Forms::PriceOrder.new(persons: 0, price:)
      end
    end
  end
end
