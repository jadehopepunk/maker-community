module Wp
  module Concerns
    module IsPostType
      extend ActiveSupport::Concern

      included do
        include Concerns::HasPostMeta

        has_many :term_relationships, class_name: 'Wp::TermRelationship', foreign_key: 'object_id'
      end

      def parent
        parent_id = post_parent&.to_i
        return nil if parent_id == 0

        Post.find(parent_id).as_subclass
      end

      def children
        Post.where(post_parent: self.ID).map(&:as_subclass)
      end

      def attachments
        Post.where(post_parent: self.ID).where(post_type: 'attachment').map(&:as_subclass)
      end

      def terms
        term_relationships.includes(term_taxonomy: :term).map(&:term_taxonomy).map(&:term)
      end

      def term_slugs
        terms.map(&:slug)
      end

      def imported_post_author
        ::User.where(wordpress_id: post_author).first
      end

      private

      def imported_record_key
        :wordpress_post_id
      end
    end
  end
end
