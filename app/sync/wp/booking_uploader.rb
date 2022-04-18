module Wp
  class BookingUploader
    def upload_bookings
      scope = EventBooking.attendees.where(wordpress_post_id: nil)
      scope.all.each do |booking|
        build_wp_booking(booking)
      end
    end

    def create_wp_booking(booking)
      raise 'Only for production' unless Rails.env.production?

      dest = build_wp_booking(booking)
      dest.save!
    end

    def build_wp_booking(booking)
      return if booking.wordpress_post_id.present?

      # We may need to create the wordpress user since users can get created in the new site
      raise ArgumentError, 'no wordpress user' unless booking.user.wordpress_id.present?

      # We don't currently create events in the new site so we are probably safe
      raise ArgumentError, 'no wordpress event' unless booking.session.event.wordpress_post_id.present?

      dest = Wp::Booking.new(
        post_author: 134,
        post_title: "New Site Booking - #{booking.session.start_at.strftime('%b %d %Y @ %-l:%M %p')}",
        post_status: 'confirmed',
        post_type: 'wc_booking',
        post_date: booking.created_at,
        post_date_gmt: booking.created_at
      )
      dest.set_meta(
        '_booking_all_day' => '0',
        '_booking_customer_id' => booking.user.wordpress_id.to_s,
        '_booking_order_item_id' => '0',
        '_booking_parent_id' => '0',
        '_booking_persons' => PHP.serialize([booking.persons]),
        '_booking_product_id' => booking.session.event.wordpress_post_id.to_s,
        '_booking_resource_id' => '0',
        '_booking_start' => booking.session.start_at.strftime('%Y%m%d%H%M%S'),
        '_booking_end' => booking.session.end_at.strftime('%Y%m%d%H%M%S'),
        '_wc_bookings_gcalendar_event_id' => '0',
        '_local_timezone' => ''
      )
      dest
    end
  end
end
