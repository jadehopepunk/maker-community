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
      sync_event_prices(dest)
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
      sync_event_prices(dest)
    end

    def shared_attributes
      {
        title: post_title,
        short_description: short_description,
        content: post_content,
        image: attachment_image,
        tag_list: product_tag_list
      }
    end

    def booking_availability
      meta_availability.map { |a| Wp::BookingAvailability.new({max_persons: }.merge(a)) }
    end

    def sync_event_sessions(event)
      booking_availability.select(&:bookable?).each do |availability|
        availability.import_or_update(event)
      end
    end

    def sync_event_prices(event)
      prices.each do |new_price|
        existing = event.prices.where(type: new_price.type).first
        unless existing
          new_price.event = event
          new_price.save!
        end
      end
    end

    def prices
      if bookable_persons.present?
        bookable_persons.map { |person| person.build_price(base_amount: base_price_amount) }
      else
        [base_price].compact
      end
    end

    def bookable_persons
      @bookable_persons ||= children_of_type(:bookable_person)
    end

    def max_persons
      meta_int('_wc_booking_max_persons_group')
    end

    private

    def meta_availability
      meta_avail_string = meta['_wc_booking_availability']
      meta_avail_string.present? ? PHP.unserialize(meta_avail_string) : []
    end

    def base_price
      return Prices::Free.new if base_price_amount.blank?

      Prices::Full.new(per_person: base_price_amount)
    end

    def base_price_amount
      meta['_price'].to_f
    end

    def short_description
      [post_excerpt, meta['_yoast_wpseo_metadesc']].reject(&:blank?).first
    end

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
