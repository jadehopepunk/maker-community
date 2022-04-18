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

  def department
    order_items.detect(&:department).try(:department)
  end

  def idempotency_key
    "order-#{id}"
  end

  def free?
    total_price_cents == 0
  end

  def payment_intent_client_secret
    return stripe_payment_intent_id if stripe_payment_intent_id.present?
    raise ArgumentError, 'creating a payment intent for a free order' if free?

    payment_intent = Stripe::PaymentIntent.create(
      {
        amount: total_price_cents,
        currency: 'aud',
        payment_method_types: ['card']
      }, {
        idempotency_key:
      }
    )

    update_attribute(:stripe_payment_intent_id, payment_intent['client_secret'])
    stripe_payment_intent_id
  end
end
