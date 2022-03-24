class Availability < ApplicationRecord
  UNKNOWN_STATE = 'unknown'.freeze
  STATES = ['busy', 'available'].freeze

  belongs_to :user
  belongs_to :creator, class_name: 'User'
  belongs_to :session, class_name: 'EventSession', foreign_key: 'event_session_id'

  validates :status, inclusion: { in: STATES }

  def self.update_for_user_and_session(session, user, status:, creator:)
    scope = where(session:, user:)

    if status == UNKNOWN_STATE
      scope.destroy_all
    else
      scope.first_or_create.update(status:, creator:)
    end
  end
end
