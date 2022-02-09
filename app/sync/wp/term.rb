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
    end
  end
end
