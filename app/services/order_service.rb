class OrderService
  def create(order)
    ActiveRecord::Base.transaction do
      order.save!

      order.order_items.each do |order_item|
        trigger_order_item_events(order, order_item)
      end
    end

    order
  end

  def fulfill_if_complete(order)
    return unless order.completed?

    order.order_items.map do |order_item|
      fulfill_item(order_item)
    end
  end

  private

  def fulfill_item(order_item)
    product = order_item.product

    if product.is_a?(EventBooking)
      fulfill_event_booking(order_item, product)
    else
      raise ArgumentError, "Unsupported product type: #{product.class}"
    end
  end

  def fulfill_event_booking(_order_item, booking)
    booking.status = 'active'
    EventBookingsService.new.update(booking)
    booking
  end

  def trigger_order_item_events(order, order_item)
    if order_item.product.is_a?(Plan)
      UserEvents::MembershipPayment.create!(
        user: order.user,
        subject: order_item,
        occured_at: order.completed_at
      )
    end
  rescue ActiveRecord::RecordInvalid => e
    e.message << ": #{order.inspect}"
    raise e
  end
end
