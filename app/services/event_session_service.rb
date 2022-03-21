class EventSessionService
  class << self
    def create(session, notify: true)
      session.save!
      puts "created event session #{session.event.slug}, #{session.start_at}"
      SlackNotifier.new.new_event_listed(session) if notify

      session
    end
  end
end
