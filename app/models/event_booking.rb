class EventBooking < ApplicationRecord
  belongs_to :user
  belongs_to :session, class_name: 'EventSession', foreign_key: 'event_session_id'
  belongs_to :order_item, optional: true

  scope :confirmed, -> { where(status: ['complete', 'paid']) }

  STATES = ['was-in-cart', 'complete', 'pending-confirmation', 'paid'].freeze

  validates :state, inclusion: { in: STATES }
end
