class Plan < ApplicationRecord
  has_many :memberships
  has_many :active_memberships, -> { active }, class_name: 'Membership'

  has_many :active_users, through: :active_memberships, source: :user

  default_scope { order(position: 'ASC') }
  scope :in_person, -> { where.not(name: 'association-member') }
  scope :has_name, ->(names) { where(name: names) }

  ROLES = {
    board_member: [:board_member],
    community_member: [:community_member, :community_concession_member, :full_time_member],
    full_time_member: [:full_time_member]
  }.freeze

  def self.update_roles
    ROLES.each do |role_name, plan_names|
      plans = Plan.has_name(plan_names)
      role = Role.find_or_create_by!(name: role_name)
      user_ids = plans.map { |plan| plan.active_users.pluck(:id) }.flatten.uniq
      role.user_ids = user_ids
      role.save!
    end
  end

  def short_title
    title.sub(/Member\z/, '')
  end
end
