module Events
  class VirtualEvent
    def find_or_create_event
      Event.find_by_slug(event_slug) || Event.create!(title:, short_description:, slug: event_slug)
    end
  end
end
