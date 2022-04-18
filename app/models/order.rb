class Order < ApplicationRecord
  STATES = ['pending', 'processing', 'failed', 'completed', 'cancelled', 'refunded'].freeze

  belongs_to :user
  has_many :order_items, dependent: :destroy

  scope :completed_in_month, ->(month) { where(completed_at: month.dates) }

  validates :status, inclusion: { in: STATES }

  def calculate_totals
    self.total_price = order_items.map(&:line_total).sum
    self.total_tax = order_items.map(&:line_tax).sum
  end

  def total_price_cents
    (total_price * 100).to_i
  end

  def completed?
    status == 'completed'
  end

  def self.for_product(product)
    item = OrderItem.where(product:).most_recent_first.first
    return nil unless item

    item.order
  end
end
