class User < ApplicationRecord
  rolify

  # Include default devise modules. Others available are:
  # , :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  has_many :memberships, dependent: :destroy
  has_many :active_memberships, -> { active }, dependent: :destroy, class_name: 'Membership'
  has_many :active_plans, through: :active_memberships, source: :plan
  has_many :events, -> { order(occured_at: :desc) }, class_name: 'UserEvent'
  has_many :orders, dependent: :destroy
  belongs_to :address, dependent: :destroy

  accepts_nested_attributes_for :address

  scope :with_plan, ->(plan) { joins(:active_plans).where(plans: { id: plan.id }) }
  scope :current_participants, -> { joins(:active_plans).merge(Plan.in_person) }

  def has_any_of_roles?(these_role_names); end
end
