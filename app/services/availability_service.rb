class AvailabilityService
  class << self
    def bulk_update(user:, creator:, entries:)
      entries.each do |date, data|
        update(user:, creator:, date:, type: data[:type], availability: data[:availability])
      end
    end

    def update(user:, creator:, date:, type:, availability:)
      virtual_event = find_virtual_event(type)
      event = virtual_event.find_or_create_event
      start_at = DateTime.parse(date.split('+').first)
      session = virtual_event.find_or_create_session(event, start_at)
      puts session.inspect
    end

    private

    def find_virtual_event(type)
      Events::VirtualCalendar.new.get_virtual_event(type)
    end
  end
end
