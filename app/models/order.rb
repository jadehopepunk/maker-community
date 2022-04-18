require 'timeout'

class Order < ApplicationRecord
  include AASM

  belongs_to :user
  has_many :order_items, dependent: :destroy

  scope :completed_in_month, ->(month) { where(completed_at: month.dates) }

  aasm column: :status do
    state :pending
    state :processing
    state :failed
    state :completed
    state :cancelled
    state :refunded

    event :complete do
      transitions from: [:pending, :processing], to: :completed, after: lambda {
        update_attribute(:completed_at, Time.current)
      }
    end
  end
  validates :status, inclusion: { in: aasm.states.map(&:name).map(&:to_s) }

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

  def payment_intent
    raise ArgumentError, 'creating a payment intent for a free order' if free?

    @payment_intent ||= (existing_payment_intent || create_payment_intent)
  end

  private

  def existing_payment_intent
    return Stripe::PaymentIntent.retrieve(stripe_payment_intent_id) if stripe_payment_intent_id.present?
  end

  def create_payment_intent
    raise ArgumentError, 'Already has a payment intent' if stripe_payment_intent_id.present?

    result = Stripe::PaymentIntent.create(
      {
        amount: total_price_cents,
        currency: 'aud',
        payment_method_types: ['card']
      }, {
        idempotency_key:
      }
    )

    update_attribute(:stripe_payment_intent_id, result['id'])

    result
  end
end
