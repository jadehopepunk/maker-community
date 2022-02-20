class EventSession < ApplicationRecord
  belongs_to :event
  has_many :bookings, dependent: :destroy, class_name: 'EventBooking'

  scope :from_this_week, -> { where('start_at >= ?', Date.today.beginning_of_week.to_time) }

  def time_range
    [start_at, end_at]
  end

  def date
    start_at&.to_date
  end
end
