class EventBookingsService
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

      SlackNotifier.new.new_event_booking(booking) if notify && booking.in_future?
      booking
    end
  end
end
