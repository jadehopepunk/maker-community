module Events
  class VirtualCalendar
    def initialize(virtual_events = nil)
      @virtual_events = virtual_events || [
        OpenTime.new,
        UnpluggedNight.new
      ]
    end

    def sessions_during(date_range)
      @virtual_events.map { |event| event.sessions_during(date_range) }.flatten
    end
  end
end
