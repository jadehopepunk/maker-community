class EventBookingsService
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

      puts "imported event booking #{booking.wordpress_post_id}"

      notify_of_create(booking) if notify
      booking
    end

    private

    def notify_of_create(booking)
      user_name = booking.user.display_name
      event_title = booking.session.event.title
      event_date = booking.session.start_at.to_date

      Slack::PostMessageJob.perform_later(
        channel: PROGRAM_CHANNEL,
        text: "`#{user_name}` booked for `#{event_title}` on #{event_date.strftime('%a, %b %d')}"
      )
    end
  end
end
