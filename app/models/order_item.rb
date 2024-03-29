def gst_included(amount)
  amount / BigDecimal('11')
end

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, polymorphic: true
  belongs_to :plan, optional: true, foreign_key: :product_id

  scope :has_plan_name, ->(names) { joins(:plan).merge(Plan.has_name(names)) }
  scope :completed_in_month, ->(month) { joins(:order).merge(Order.completed_in_month(month)) }
  scope :most_recent_first, -> { joins(:order).order('orders.created_at' => :desc) }

  def calculate_totals
    self.line_total = line_subtotal * quantity
    self.line_tax = gst_included(line_total)
  end

  def department
    product&.department
  end
end
