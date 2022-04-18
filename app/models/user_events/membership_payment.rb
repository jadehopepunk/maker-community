module UserEvents
  class MembershipPayment < UserEvent
    def order_item
      subject
    end

    def plan
      order_item&.product
    end
  end
end
