module Wp
  class UserMeta < Wp::Base
    self.table_name = 'wp_usermeta'

    belongs_to :user, class_name: 'Wp::User'
  end
end
