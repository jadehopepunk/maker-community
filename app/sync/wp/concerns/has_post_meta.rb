module Wp
  module Concerns
    module HasPostMeta
      extend ActiveSupport::Concern

      included do
        has_many :post_meta, foreign_key: :post_id, class_name: 'Wp::PostMeta'

        scope :with_meta, -> { includes(:post_meta) }
      end

      def meta
        @meta ||= PostMeta.convert_to_hash(post_meta)
      end

      def meta_int(key)
        meta[key].present? ? meta[key].to_i : nil
      end
    end
  end
end
