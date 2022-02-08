module Wp
  class Product < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    default_scope { where(post_type: 'product') }

    def destination_record
      plan_destination
    end

    private

    def plan_destination
      ::Plan.where(wordpress_product_id: self.ID).first
    end
  end
end
