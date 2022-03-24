module VirtualEvents
  class VirtualEvent
    def find_or_create_event
      Event.find_by_slug(event_slug) || Event.create!(title:, short_description:, slug: event_slug)
    end

    def find_or_create_session(event, start_time)
      virtual_session = find_virtual_session(start_time)
      raise ArgumentError, "Could not find virtual session for start_time #{start_time.inspect}" unless virtual_session

      virtual_session.find_or_create_session(event)
    end

    def find_virtual_session(start_time)
      date = start_time.to_date
      candidates = virtual_sessions_during(date..date)
      candidates.find do |session|
        session.start_at.hour == start_time.hour && session.start_at.min == start_time.min
      end
    end
  end
end
