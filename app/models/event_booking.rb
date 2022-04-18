class EventBooking < ApplicationRecord
  STATES = ['was-in-cart', 'in-cart', 'pending-confirmation', 'active', 'cancelled'].freeze
  CONFIRMED_STATES = ['complete', 'paid'].freeze
  ROLES = ['attendee', 'duty_manager', 'teacher', 'volunteer'].freeze

  belongs_to :user
  belongs_to :session, class_name: 'EventSession', foreign_key: 'event_session_id'
  belongs_to :order_item, optional: true

  scope :active, -> { where(status: 'active') }
  scope :in_cart, -> { where(status: 'in-cart') }
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

  def active?
    status == 'active'
  end

  def cancelled?
    status == 'cancelled'
  end
end
