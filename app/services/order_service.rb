class OrderService
  class << self
    def create(order)
      order.save!
    end
  end
end
