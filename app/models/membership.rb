class Membership < ApplicationRecord
  STATES = %w[active expired cancelled paused pending].freeze

  belongs_to :user
  belongs_to :plan
  belongs_to :subscription, optional: true

  scope :active, -> { where(status: 'active') }
end
