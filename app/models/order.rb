class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  scope :completed_in_month, ->(month) { where(completed_at: month.dates) }
end
