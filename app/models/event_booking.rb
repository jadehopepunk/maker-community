class EventBooking < ApplicationRecord
  belongs_to :user
  belongs_to :event_session
  belongs_to :order_item, optional: true
end
