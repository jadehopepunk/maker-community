class Membership < ApplicationRecord
  STATES = ['active', 'expired', 'cancelled', 'paused', 'pending'].freeze

  belongs_to :user
  belongs_to :plan
  belongs_to :subscription, optional: true

  scope :active, -> { where(status: 'active').active_on(Date.current) }
  scope :active_on, ->(date) { where('start_at <= :date AND (end_at >= :date OR end_at IS NULL)', date:) }
  scope :has_plan_name, ->(names) { joins(:plan).merge(Plan.has_name(names)) }
end
