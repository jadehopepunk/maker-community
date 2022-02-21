module Wp
  class Term < Wp::Base
    self.table_name = 'wp_terms'

    has_many :term_taxonomies
    has_many :term_relationships, through: :term_taxonomies
    has_many :posts, through: :term_relationships

    class << self
      def events
        find_by_slug 'events'
      end

      def inductions
        find_by_slug 'inductions'
      end

      def post_ids
        term_relationships.pluck(:object_id)
      end

      def sync
        TermTaxonomy.product_tags.includes(:term).map(&:term).each(&:import_if_new)
      end

      def dest_class
        ::Tag
      end
    end

    def import_new
      dest = dest_class.create!(
        title: name,
        slug:,
        wordpress_term_id: term_id
      )
      puts "imported tag #{name}"
      dest
    end

    def imported_record_key
      :wordpress_term_id
    end

    def primary_key
      term_id
    end

    def imported_tag
      existing_dest
    end
  end
end
