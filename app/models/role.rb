class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles

  SUBSCRIPTION_ROLES = [
    'community_member',
    'full_time_member',
  ]

  APPOINTED_ROLES = [
    'president',
    'vice_president',
    'treasurer',
    'secretary',
    'board_member',
    'duty_manager',
    'people_admin',
    'program_admin',
    'duty_roster_admin',
    'place_admin',
    'teacher',
    'website_dev'
  ].freeze

  ROLES = SUBSCRIPTION_ROLES + APPOINTED_ROLES

  belongs_to :resource, polymorphic: true, optional: true
  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true
  validates :name, inclusion: { in: ROLES }

  scopify

  scope :subscription, -> { where(name: SUBSCRIPTION_ROLES) }
  scope :appointed, -> { where(name: APPOINTED_ROLES) }

  def display_name
    name.titleize
  end
end
