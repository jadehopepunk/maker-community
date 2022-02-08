class OrderService
  class << self
    def create(order)
      order.save!

      order.order_items.each do |order_item|
        trigger_order_item_events(order, order_item)
      end

      order
    end

    private

    def trigger_order_item_events(order, order_item)
      if order_item.product.is_a?(Plan)
        UserEvents::MembershipPayment.create!(
          user: order.user,
          subject: order_item,
          occured_at: order.completed_at
        )
      end
    end
  end
end
