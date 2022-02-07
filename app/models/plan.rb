class Plan < ApplicationRecord
  has_many :memberships
  has_many :active_memberships, -> { active }, class_name: 'Membership'

  has_many :active_users, through: :active_memberships, source: :user

  default_scope { order(position: 'ASC') }
end
