class EventSession < ApplicationRecord
  belongs_to :event
  has_many :bookings, dependent: :destroy, class_name: 'EventBooking'
  has_many :availabilities

  validates :start_at, presence: true

  scope :from_this_week, -> { where('start_at >= ?', Date.current.beginning_of_week.to_time) }
  scope :in_date_range, ->(date_range) { where(start_at: date_range) }
  scope :future, -> { where('start_at >= ?', Date.current) }
  scope :tagged_with, lambda { |tags|
    return self if tags.empty?

    where(event_id: Event.tagged_with(tags).pluck(:id))
  }

  delegate :title, to: :event

  def time_range
    [start_at, end_at]
  end

  def date
    start_at&.to_date
  end

  def self.tag_counts(session_scope)
    ActsAsTaggableOn::Tagging
      .where(taggable_type: 'Event', context: 'tags')
      .joins(:tag)
      .joins("INNER JOIN events ON taggings.taggable_id = events.id AND taggings.taggable_type = 'Event'")
      .joins('INNER JOIN event_sessions ON events.id = event_sessions.event_id')
      .where(event_sessions: { id: session_scope.pluck(:id) })
      .group('tags.name')
      .pluck('tags.name', 'COUNT(taggable_id)')
      .to_h
  end

  def in_future?
    start_at >= DateTime.current
  end

  def string_identifier
    id
  end

  def availability_status(user)
    hashed_availability_states[user.id]
  end

  private

  def hashed_availability_states
    @hashed_availability_states ||= availabilities.pluck(:user_id, :status).to_h
  end
end
