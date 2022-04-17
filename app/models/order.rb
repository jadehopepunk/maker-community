class Order < ApplicationRecord
  STATES = ['pending', 'processing', 'failed', 'completed', 'cancelled', 'refunded'].freeze

  belongs_to :user
  has_many :order_items, dependent: :destroy

  scope :completed_in_month, ->(month) { where(completed_at: month.dates) }

  validates :status, inclusion: { in: STATES }

  def calculate_totals
    self.total_price = order_items.sum(:price)
    self.total_tax = order_items.sum(:tax)
  end
end
