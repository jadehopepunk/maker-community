class UserMembership < ApplicationRecord
  belongs_to :user
  belongs_to :membership_plan
  belongs_to :subscription, optional: true

  STATES = %w[active expired cancelled paused pending].freeze
end
