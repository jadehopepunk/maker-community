class EventSession < ApplicationRecord
  belongs_to :event
  has_many :bookings, dependent: :destroy, class_name: 'EventBooking'

  scope :from_this_week, -> { where('start_at >= ?', Date.today.beginning_of_week.to_time) }
  scope :tagged_with, lambda { |tags|
    return self if tags.empty?

    where(event_id: Event.tagged_with(tags).pluck(:id))
  }

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
end
