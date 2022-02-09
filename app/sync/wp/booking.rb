module Wp
  class Booking < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    default_scope { where(post_type: 'wc_booking') }

    class << self
      def sync
        find_each(&:import_if_new)
      end
    end

    def import_if_new
      import_new unless ::EventBooking.where(wordpress_post_id: self.ID).exists?
    end

    def import_new
      import_event_session
    end

    def import_event_session
      puts "No event for #{self.ID} status:#{post_status}" if event.nil?
    end

    def event
      @event ||= ::Event.where(wordpress_post_id: event_post_id).first
    end

    def event_post_id
      raise 'event _booking_product_id not found' unless meta_hash['_booking_product_id']

      meta_hash['_booking_product_id'].to_i
    end
  end
end
