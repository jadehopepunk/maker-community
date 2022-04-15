module Wp
  class Booking < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    default_scope { where(post_type: 'wc_booking') }
    scope :excluding_cart, -> { where.not(post_status: 'was-in-cart') }

    class << self
      def dest_class
        ::EventBooking
      end

      def sync
        excluding_cart.find_each(&:import_if_new)
      end
    end

    def import_new
      event_session = import_event_session_if_new
      user = imported_customer
      order_item = imported_order_item

      if user.nil?
        puts "skipping booking #{self.ID} as it has no customer"
        return
      end

      puts "about to import wp booking #{self.ID}"

      dest = ::EventBooking.new(
        session: event_session,
        user:,
        order_item:,
        status: post_status,
        persons: booking_persons,
        wordpress_post_id: self.ID,
        created_at: post_date
      )
      EventBookingsService.new.create(dest)
    end

    def import_event_session_if_new
      raise "No event for #{self.ID} status:#{post_status}" if event.nil?

      session = ::EventSession.where(event:, start_at: booking_start).first
      session || import_event_session
    end

    def import_event_session
      dest = ::EventSession.create!(
        event:,
        start_at: booking_start,
        end_at: booking_end
      )
      puts "imported event session #{event.slug}, #{dest.start_at}"
      dest
    end

    def event
      @event ||= ::Event.where(wordpress_post_id: event_post_id).first
    end

    def event_post_id
      raise 'event _booking_product_id not found' unless meta['_booking_product_id']

      meta['_booking_product_id'].to_i
    end

    def booking_start
      meta['_booking_start'].in_time_zone(Time.zone)
    end

    def booking_end
      meta['_booking_end'].in_time_zone(Time.zone)
    end

    def imported_order_item
      ::OrderItem.where(wordpress_id: order_item_id).first
    end

    def imported_customer
      ::User.where(wordpress_id: customer_id).first
    end

    def order_item_id
      meta['_booking_order_item_id'].to_i
    end

    def customer_id
      meta['_booking_customer_id'].to_i
    end

    def booking_persons
      if meta_booking_persons.is_a?(Array)
        meta_booking_persons.sum
      elsif meta_booking_persons.is_a?(Hash)
        meta_booking_persons.values.sum
      else
        raise "What do we do here? #{meta_booking_persons.class}"
      end
    end

    def meta_booking_persons
      PHP.unserialize(meta['_booking_persons'])
    end
  end
end
