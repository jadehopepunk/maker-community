module Wp
  class Event < Wp::Product
    class << self
      def all_events
        find Wp::Term.events.post_ids
      end

      def sync
        all_events.each(&:import_if_new)
      end
    end

    def import_if_new
      import_new unless ::Event.where(wordpress_post_id: self.ID).exists?
    end

    def import_new
      author = ::User.find_by_wordpress_id(post_author)

      dest = ::Event.create!(
        slug: post_name,
        author:,
        title: post_title,
        content: post_content,
        wordpress_post_id: self.ID,
        created_at: post_date
      )
      puts "imported event #{dest.title}"
      dest
    end

    def booking_availability
      PHP.unserialize meta_hash['_wc_booking_availability']
    end
  end
end
