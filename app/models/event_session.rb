class EventSession < ApplicationRecord
  belongs_to :event
  has_many :bookings, dependent: :destroy, class_name: "EventBooking"
end
