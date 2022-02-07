class User < ApplicationRecord
  rolify

  # Include default devise modules. Others available are:
  # , :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  has_many :memberships
  has_many :active_memberships, -> { active }, class_name: 'Membership'
  has_many :active_plans, through: :active_memberships, source: :plan
  has_many :events, class_name: 'UserEvent'

  scope :with_plan, ->(plan) { joins(:active_plans).where(plans: { id: plan.id }) }
end
