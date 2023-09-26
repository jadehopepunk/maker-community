class EventSession < ApplicationRecord
  belongs_to :event
  has_many :bookings, dependent: :destroy, class_name: 'EventBooking'
  has_many :manager_bookings, -> { duty_managers }, class_name: 'EventBooking'
  has_many :availabilities

  validates :start_at, presence: true

  scope :date_order, -> { order(:start_at) }
  scope :from_this_week, -> { where('start_at >= ?', Date.current.beginning_of_week.to_time) }
  scope :in_date_range, ->(date_range) { where(start_at: DateUtilities.date_range_to_datetime_range(date_range)) }
  scope :future, -> { where('event_sessions.start_at >= ?', Date.current.to_datetime) }
  scope :today, -> { where(start_at: DateUtilities.next_n_hours(24)) }
  scope :on_date, ->(date) { in_date_range(date.beginning_of_day..date.end_of_day) }
  scope :tagged_with, lambda { |tags|
    return self if tags.empty?

    where(event_id: Event.tagged_with(tags).pluck(:id))
  }
  scope :only_duty_managed_until, lambda { |date|
                                    joins(:event).where("events.duty_managed = 'f' OR (events.duty_managed = 't' AND start_at <= ?)", date)
                                  }
  scope :special_event, -> { joins(:event).merge(Event.special_event) }
  scope :duty_managed, -> { joins(:event).merge(Event.duty_managed) }

  delegate :title, :short_description, :image, :prices, :duty_managed, to: :event

  def self.one_session_per_day(sessions, limit: nil)
    previous = nil
    result = sessions.each_with_object([]) do |session, result|
      result << session if previous.nil? || previous.date != session.date
      previous = session
    end

    limit ? result.first(limit) : result
  end

  def time_range
    [start_at, end_at]
  end

  def date
    start_at&.to_date
  end

  def duty_managers
    manager_bookings.map(&:user)
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

  def location
    '70 Saxon St, Brunswick 3056 VIC, Australia'
  end

  def wordpress_url
    "https://makercommunity.org.au/product/#{event.slug}/?wbc_cal_start=#{start_at.to_i}&wbc_cal_end=#{end_at.to_i}"
  end

  def has_person_limit?
    max_persons.present?
  end

  def remaining_persons
    return nil if max_persons.nil?

    max_persons - booked_persons
  end

  def booked_persons
    bookings.active.sum(:persons)
  end

  def to_param
    [id.to_s, event.slug].reject(&:blank?).join('-')
  end

  def active_booking_for(user)
    return nil if user.nil?

    bookings.active.find_by(user:)
  end

  def find_all_day_sessions
    event.find_day_sessions(start_at)
  end

  def override_with(other_session_id)
    other_session = EventSession.find(other_session_id)
    self.attributes = other_session.attributes.except('id')
    save!
    other_session.delete
  end

  def self.ransackable_attributes(_auth_objectr = nil)
    ['event_title']
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def hashed_availability_states
    @hashed_availability_states ||= availabilities.pluck(:user_id, :status).to_h
  end
end
