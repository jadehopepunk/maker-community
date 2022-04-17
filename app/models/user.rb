class User < ApplicationRecord
  rolify

  SIGN_UP_STATES = ['full', 'imported', 'unclaimed'].freeze

  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  has_many :memberships, dependent: :destroy
  has_many :active_memberships, -> { active }, dependent: :destroy, class_name: 'Membership'
  has_many :active_plans, through: :active_memberships, source: :plan
  has_many :events, -> { order(occured_at: :desc) }, class_name: 'UserEvent'
  has_many :orders, dependent: :destroy
  has_many :user_inductions, dependent: :destroy
  has_many :inductions, through: :user_inductions
  has_many :bookings, class_name: 'EventBooking', dependent: :destroy
  belongs_to :address, dependent: :destroy, optional: true
  has_one :slack_user

  scope :with_plan, ->(plan) { joins(:active_plans).where(plans: { id: plan.id }) }
  scope :current_participants, -> { joins(:active_plans).merge(Plan.in_person) }

  validates :sign_up_status, inclusion: { in: SIGN_UP_STATES }

  delegate :has_avatar?, :avatar_url, to: :slack_user, allow_nil: true

  def short_name
    display_name.split(' ').first
  end

  def self.jade
    where(display_name: 'Jade').first
  end

  def password_imported?
    sign_up_status == 'imported'
  end

  def has_one_of_plans?(plan_names)
    active_plans.has_name(plan_names).exists?
  end
end
