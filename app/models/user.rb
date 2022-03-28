class User < ApplicationRecord
  rolify

  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  has_many :memberships, dependent: :destroy
  has_many :active_memberships, -> { active }, dependent: :destroy, class_name: 'Membership'
  has_many :active_plans, through: :active_memberships, source: :plan
  has_many :events, -> { order(occured_at: :desc) }, class_name: 'UserEvent'
  has_many :orders, dependent: :destroy
  has_many :user_inductions, dependent: :destroy
  has_many :inductions, through: :user_inductions
  belongs_to :address, dependent: :destroy, optional: true
  has_one :slack_user

  scope :with_plan, ->(plan) { joins(:active_plans).where(plans: { id: plan.id }) }
  scope :current_participants, -> { joins(:active_plans).merge(Plan.in_person) }

  delegate :has_avatar?, :avatar_url, to: :slack_user, allow_nil: true

  def short_name
    display_name.split(' ').first
  end
end
