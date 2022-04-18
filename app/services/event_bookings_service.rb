class EventBookingsService
  def create(booking, notify: true)
    ActiveRecord::Base.transaction do
      booking.save!
      create_user_event(booking) if booking.active?
    end

    puts "created event booking #{booking.wordpress_post_id}"

    SlackNotifier.new.new_event_booking(booking) if notify && booking.in_future? && booking.active?
    booking
  end

  def update(booking, notify: true)
    if booking.changes[:status].present?
      old_status = booking.changes[:status].first
      new_status = booking.changes[:status].last
      notify_booking_status_changed(booking, old_status, new_status) if notify && booking.in_future?
    end

    booking.save!
  end

  private

  def notify_booking_status_changed(booking, old_status, new_status)
    if new_status == 'cancelled'
      SlackNotifier.new.cancelled_event_booking(booking)
    elsif old_status != 'active' && new_status == 'active'
      SlackNotifier.new.new_event_booking(booking)
      create_user_event(booking)
    end
  end

  def create_user_event(booking)
    UserEvents::BookedForEvent.create!(
      user: booking.user,
      subject: booking,
      occured_at: booking.session.start_at
    )
  end
end
