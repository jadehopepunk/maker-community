class AvailabilityService
  class << self
    def bulk_update(user:, creator:, entries:)
      entries.each do |session_id, status|
        update(user:, creator:, session_id:, status:)
      end
    end

    def update(user:, creator:, session_id:, status:)
      session = EventSession.find(session_id)
      Availability.update_for_user_and_session(session, user, creator:, status:)
    end
  end
end
