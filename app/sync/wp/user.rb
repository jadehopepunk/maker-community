module Wp
  class User < Wp::Base
    self.table_name = 'wp_users'

    class << self
      def sync
        all.each do |wp_user|
          existing = ::User.find_by_email(wp_user.user_email)
          create(wp_user) unless existing
          puts existing.inspect
        end
      end

      def create(wp_user)
        user = ::User.new(
          email: wp_user.user_email,
          password: wp_user.user_pass,
          display_name: wp_user.display_name,
          wordpress_id: wp_user.ID,
          created_at: wp_user.user_registered
        )
        user.save!
      end
    end
  end
end
