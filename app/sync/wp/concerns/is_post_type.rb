module Wp
  module Concerns
    module IsPostType
      extend ActiveSupport::Concern

      included do
        include Concerns::HasPostMeta
      end

      def parent
        parent_id = post_parent&.to_i
        return nil if parent_id == 0

        Post.find(parent_id).as_subclass
      end

      def children
        Post.where(post_parent: self.ID).map(&:as_subclass)
      end
    end
  end
end
