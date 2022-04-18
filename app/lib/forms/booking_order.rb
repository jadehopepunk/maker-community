module Forms
  class BookingOrder
    include ActiveModel::Model

    attr_accessor :user, :price_orders, :email, :name, :comments
    attr_reader :event_session, :order, :booking

    validates :email, presence: true,
                      format: { with: Devise.email_regexp, message: "doesn't look like a valid email address" }, unless: :user
    validates_each :user, if: :user do |record, attr, value|
      if record.event_session.active_booking_for(value).present?
        record.errors.add(attr,
                          'you already have a booking for this event')
      end
    end
    validates :name, presence: true, unless: :user
    validates_each :email, unless: :user do |record, _attr, value|
      if User.claimed.where(email: value).exists?
        record.errors.add(:email, :email_exists,
                          message: 'already has an account here, please sign in instead')
      end
    end
    validates :total_persons, comparison: { greater_than: 0, message: 'you must select at least one person' }

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
      (price_orders || []).map(&:persons).sum
    end

    def total_price
      (price_orders || []).map(&:total_price).sum
    end

    def save
      raise ArgumentError, 'This needs to be setup with an event session' unless event_session.present?

      if valid?
        ActiveRecord::Base.transaction do
          save_booking!
          save_order!
        end
        return true
      end

      false
    end

    def existing_booking=(value)
      @booking = value
      self.comments = value.comments
      @order = order
    end

    private

    def free?
      total_price == BigDecimal('0.0')
    end

    def save_order!
      @order ||= Order.new(
        user: best_user
      )
      @order.attributes = {
        status: (free? ? 'completed' : 'pending'),
        order_items: [build_order_item]
      }
      @order.calculate_totals
      @order.save!
    end

    def save_booking!
      @booking ||= EventBooking.new(
        user: best_user,
        session: event_session,
        status: 'in-cart'
      )
      @booking.attributes = {
        persons: total_persons,
        comments:
      }
      @booking.save!
    end

    def build_order_item
      result = OrderItem.new(
        product: @booking,
        name: event_session.title,
        quantity: 1,
        line_subtotal: total_price
      )
      result.calculate_totals
      result
    end

    def build_booking
      EventBooking.new(user: best_user, session: event_session, status: 'complete',
                       persons: total_persons, comments:)
    end

    def best_user
      user || email_user
    end

    def email_user
      existing_email_user || create_email_user
    end

    def create_email_user
      User.create!(email:, display_name: name, sign_up_status: 'unclaimed')
    end

    def existing_email_user
      User.unclaimed.where(email:).first
    end

    def set_price_orders
      @price_orders = prices.map do |price|
        Forms::PriceOrder.new(persons: 0, price:)
      end
    end
  end
end
