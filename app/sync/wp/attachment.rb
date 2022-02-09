module Wp
  class Attachment < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    default_scope { where(post_type: 'attachment') }
  end
end
