class Availability < ApplicationRecord
  UNKNOWN_STATE = 'unknown'
  STATES = ['busy', 'available'].freeze

  belongs_to :user
  belongs_to :creator, class_name: 'User'
  belongs_to :session, class_name: 'EventSession', foreign_key: 'event_session_id'

  validates :status, inclusion: { in: STATES }

  def self.update_for_user_and_session(session, user, attributes)
    where(session:, user:).first_or_create.update(attributes)
  end
end
