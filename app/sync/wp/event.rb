module Wp
  class Event < Wp::Product
    class << self
      def dest_class
        ::Event
      end

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
        all_events.each(&:import_or_update)
      end
    end

    def existing_dest
      @dest ||= dest_class.where(wordpress_post_id: self.ID).first
    end

    def import_new
      author = ::User.find_by_wordpress_id(post_author)

      dest = dest_class.create!(
        slug: post_name,
        author:,
        **shared_attributes,
        wordpress_post_id: self.ID,
        created_at: post_date
      )
      sync_event_sessions(dest)
      puts "imported event #{dest.title}"
      dest
    end

    def update_existing
      dest = existing_dest

      dest.assign_attributes shared_attributes
      if dest.changed?
        dest.save!
        puts "updated event: #{dest.title}"
      end
      sync_event_sessions(dest)
    end

    def shared_attributes
      {
        title: post_title,
        short_description: post_excerpt,
        content: post_content,
        image: attachment_image,
        tag_list: product_tag_list
      }
    end

    def booking_availability
      meta_avail_string = meta['_wc_booking_availability']
      meta_avail = meta_avail_string.present? ? PHP.unserialize(meta_avail_string) : []
      meta_avail.map { |a| Wp::BookingAvailability.new(a) }
    end

    def sync_event_sessions(event)
      booking_availability.select(&:bookable?).each do |availability|
        availability.import_event_session_if_new(event)
      end
    end

    private

    def product_tag_list
      terms.map(&:slug) & TermTaxonomy.product_tags.map(&:term).map(&:slug)
    end

    def attachment_image
      attachment&.existing_dest
    end

    def attachment
      thumbnail || attachments.first
    end

    def thumbnail
      Wp::Attachment.find(meta['_thumbnail_id']) if meta['_thumbnail_id']
    end
  end
end
