class EventBookingsService
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

    SlackNotifier.new.new_event_booking(booking) if notify && booking.in_future? && booking.confirmed?
    booking
  end

  def update(booking, notify: true)
    booking.save!

    if booking.changes[:status].present?
      old_status = booking.changes[:status].first
      new_status = booking.changes[:status].last
      notify_booking_status_changed(booking, old_status, new_status) if notify && booking.in_future?
    end
  end

  private

  def notify_booking_status_changed(booking, old_status, new_status)
    if new_status == 'cancelled'
      SlackNotifier.new.cancelled_event_booking(booking)
    elsif old_status == 'cancelled'
      SlackNotifier.new.new_event_booking(booking)
    end
  end
end
