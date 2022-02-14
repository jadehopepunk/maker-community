class EventBookingsService
  class << self
    def create(booking)
      ActiveRecord::Base.transaction do
        booking.save!

        UserEvents::BookedForEvent.create!(
          user: booking.user,
          subject: booking,
          occured_at: booking.session.start_at
        )
      end

      puts "imported event booking #{booking.wordpress_post_id}"

      booking
    end
  end
end
