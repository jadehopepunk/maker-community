class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles

  ROLES = %w[
    president
    vice_president
    treasurer
    secretary
    board_member
    duty_manager
    people_admin
    program_admin
    place_admin
  ].freeze

  belongs_to :resource, polymorphic: true, optional: true
  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true
  validates :name, inclusion: { in: ROLES }

  scopify

  def display_name
    name.titleize
  end
end
