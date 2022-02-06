module Wp
  module Concerns
    module HasPostMeta
      extend ActiveSupport::Concern

      included do
        has_many :post_meta, foreign_key: :post_id, class_name: 'Wp::PostMeta'
      end

      def post_meta_hash
        PostMeta.convert_to_hash(post_meta)
      end
    end
  end
end
