module UserEvents
  class BookedForEvent < UserEvent
    def booking
      subject
    end

    def event_session
      booking&.session
    end

    def event
      event_session.event
    end
  end
end
