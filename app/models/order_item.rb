class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, polymorphic: true
  belongs_to :plan, optional: true, foreign_key: :product_id

  scope :has_plan_name, ->(names) { joins(:plan).merge(Plan.has_name(names)) }
  scope :completed_in_month, ->(month) { joins(:order).merge(Order.completed_in_month(month)) }
end
