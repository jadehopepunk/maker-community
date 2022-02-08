module Wp
  class Product < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::HasPostMeta

    default_scope { where(post_type: 'product') }
  end
end
