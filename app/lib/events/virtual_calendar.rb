module Events
  class VirtualCalendar
    def initialize(virtual_events = nil)
      @virtual_events = virtual_events || [
        OpenTime.new,
        UnpluggedNight.new
      ]
    end

    def sessions_during(date_range)
      sort_by_start_time @virtual_events.map { |event| event.sessions_during(date_range) }.flatten
    end

    private

    def sort_by_start_time(sessions)
      sessions.sort do |a, b|
        a.start_at <=> b.start_at
      end
    end
  end
end
