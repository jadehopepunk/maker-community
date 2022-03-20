class EventSessionService
  class << self
    include DatetimeHelper

    def create(session, notify: true)
      session.save!
      puts "created event session #{session.event.slug}, #{session.start_at}"
      notify_of_create(session) if notify

      session
    end

    private

    def notify_of_create(session)
      Slack::PostMessageJob.perform_later(
        channel: '#general',
        text: <<~TEXT
          New event: *#{session.event.title}*
          #{session.start_at.strftime('%a, %b %-d')} at #{format_time_text session.start_at}

          See it on our #{slack_link_to 'events page', 'https://makercommunity.org.au/events/'}
        TEXT
      )
    end

    def slack_link_to(title, url)
      "<#{url}|#{title}>"
    end
  end
end
