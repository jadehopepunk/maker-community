module Wp
  class Product < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    default_scope { where(post_type: 'product') }

    def destination_record
      plan_destination
    end

    def is_event?
      term_slugs.include? 'events'
    end

    def product_attributes
      result = meta['_product_attributes']
      return {} unless result

      PHP.unserialize(result)
    end

    private

    def plan_destination
      if is_event?
        ::Event.where(wordpress_post_id: self.ID).first
      else
        ::Plan.where(wordpress_product_id: self.ID).first
      end
    end
  end
end
