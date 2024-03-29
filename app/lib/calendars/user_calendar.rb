module Calendars
  class UserCalendar
    def initialize(user)
      @user = user
    end

    def event_bookings
      @event_bookings ||= bookings_scope
    end

    def name
      "Maker Community bookings for #{user.display_name}"
    end

    private

    attr_reader :user

    def bookings_scope
      user.bookings.includes(:session).order('event_sessions.start_at ASC')
    end
  end
end
