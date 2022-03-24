class AvailabilityService
  class << self
    def bulk_update(user:, creator:, entries:)
      entries.each do |date, data|
        update(user:, creator:, date:, type: data[:type], availability: data[:availability])
      end
    end

    def update(user:, creator:, date:, type:, availability:)
      event = event_for_type(type)
    end

    private

    def event_for_type(type)
      result = Events::VirtualCalendar.new.get_virtual_event(type)
      result.find_or_create_event
    end
  end
end
