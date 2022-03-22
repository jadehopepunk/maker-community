class Availability < ApplicationRecord
  belongs_to :user
  belongs_to :session, class_name: 'EventSession', foreign_key: 'event_session_id'
end
