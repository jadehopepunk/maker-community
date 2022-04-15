class EventBooking < ApplicationRecord
  STATES = ['was-in-cart', 'in-cart', 'complete', 'pending-confirmation', 'paid'].freeze
  CONFIRMED_STATES = ['complete', 'paid'].freeze
  ROLES = ['attendee', 'duty_manager', 'teacher', 'volunteer'].freeze

  belongs_to :user
  belongs_to :session, class_name: 'EventSession', foreign_key: 'event_session_id'
  belongs_to :order_item, optional: true

  scope :confirmed, -> { where(status: CONFIRMED_STATES) }
  scope :duty_managers, -> { where(role: 'duty_manager') }

  validates :status, inclusion: { in: STATES }
  validates :role, inclusion: { in: ROLES }

  delegate :in_future?, to: :session

  def user_calendar_title
    if role == 'attendee'
      session.title
    else
      "#{role.humanize.titleize} - #{session.title}"
    end
  end

  def confirmed?
    CONFIRMED_STATES.include?(status)
  end
end
