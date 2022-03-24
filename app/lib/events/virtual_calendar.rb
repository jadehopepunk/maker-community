module Events
  class VirtualCalendar
    VALID_EVENT_TYPES = ['Events::UnpluggedNight', 'Events::OpenTime'].freeze

    def initialize(virtual_events = nil)
      @virtual_events = virtual_events || [
        OpenTime.new,
        UnpluggedNight.new
      ]
    end

    def virtual_sessions_during(date_range)
      sort_by_start_time @virtual_events.map { |event| event.virtual_sessions_during(date_range) }.flatten
    end

    def get_virtual_event(type)
      raise ArgumentError, "invalid event type: #{type.inspect}" unless VALID_EVENT_TYPES.include?(type)

      type.constantize.new
    end

    private

    def sort_by_start_time(sessions)
      sessions.sort do |a, b|
        a.start_at <=> b.start_at
      end
    end
  end
end
