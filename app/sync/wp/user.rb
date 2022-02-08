module Wp
  class User < Wp::Base
    self.table_name = 'wp_users'

    class << self
      def dest_class
        ::User
      end

      def sync
        find_each do |record|
          record.import_new unless dest_class.where(wordpress_id: record.ID).exists?
        end
      end
    end

    def import_new
      user = self.class.dest_class.new(
        email: user_email,
        password: user_pass,
        display_name: display_name,
        wordpress_id: self.ID,
        created_at: user_registered
      )
      user.save!
      puts "imported user #{user.display_name}"
    end
  end
end
