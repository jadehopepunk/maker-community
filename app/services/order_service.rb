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

  def fulfill(order)
    results = []
    order.order_items.each do |order_item|
      build_item_fulfillment(order_item, results)
    end
    results
  end

  private

  def build_item_fulfillment(order_item, results)
    product = order_item.product

    if product.is_a?(EventSession)
      fulfill_event_session(order_item, product, results)
    else
      raise ArgumentError, "Unsupported product type: #{product.class}"
    end
  end

  def fulfill_event_session(order_item, event_session, results)
    booking = EventBooking.new(
      user: order_item.order.user,
      session: event_session,
      status: 'complete',
      persons: order_item.quantity,
      comments: order_item.order.comments,
      order_item:
    )
    results << booking
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
