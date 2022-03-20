class EventBookingsService
  include Rails.application.routes.url_helpers

  PROGRAM_CHANNEL = '#team-program'.freeze

  class << self
    def create(booking, notify: true)
      ActiveRecord::Base.transaction do
        booking.save!

        UserEvents::BookedForEvent.create!(
          user: booking.user,
          subject: booking,
          occured_at: booking.session.start_at
        )
      end

      puts "created event booking #{booking.wordpress_post_id}"

      notify_of_create(booking) if notify
      booking
    end

    private

    def notify_of_create(booking)
      user_name = booking.user.display_name
      event_title = booking.session.event.title
      event_date = booking.session.start_at.to_date

      people_count = booking.persons > 1 ? " #{booking.persons} people" : ''
      event_link = slack_link_to event_title, url_helpers.admin_event_session_url(booking.session)

      Slack::PostMessageJob.perform_later(
        channel: PROGRAM_CHANNEL,
        text: "`#{user_name}` booked#{people_count} for #{event_link} on #{event_date.strftime('%a, %b %d')}"
      )
    end

    def slack_link_to(title, url)
      "<#{url}|#{title}>"
    end

    def url_helpers
      Rails.application.routes.url_helpers
    end
  end
end
