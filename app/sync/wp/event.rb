module Wp
  class Event < Wp::Product
    class << self
      def all_events
        terms = [
          Wp::Term.events,
          Wp::Term.inductions
        ]
        custom_ids = [6264, 6241]
        ids = (custom_ids + terms.map(&:post_ids).flatten).uniq
        find ids
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
      PHP.unserialize meta['_wc_booking_availability']
    end
  end
end
