module Wp
  class User < Wp::Base
    self.table_name = 'wp_users'

    class << self
      def dest_class
        ::User
      end

      def sync
        find_each do |record|
          import_new(record) unless dest_class.where(wordpress_id: record.ID).exists?
        end
      end

      def import_new(wp_user)
        user = dest_class.new(
          email: wp_user.user_email,
          password: wp_user.user_pass,
          display_name: wp_user.display_name,
          wordpress_id: wp_user.ID,
          created_at: wp_user.user_registered
        )
        user.save!
        puts "imported user #{user.display_name}"
      end
    end
  end
end
