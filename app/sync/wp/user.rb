module Wp
  class User < Wp::Base
    self.table_name = 'wp_users'

    class << self
      def dest_class
        ::User
      end

      def sync
        find_each(&:import_or_update)
      end
    end

    def import_or_update
      if existing_dest
        update_existing
      else
        import_new
      end
    end

    def existing_dest
      @dest ||= dest_class.where(wordpress_id: self.ID).first
    end

    def import_new
      user = dest_class.new(
        email: user_email,
        password: user_pass,
        display_name:,
        wordpress_id: self.ID,
        created_at: user_registered
      )
      user.save!
      puts "imported user #{user.display_name}"
    end

    def update_existing
      dest = existing_dest

      dest.email = user_email
      dest.display_name = display_name
      if dest.changed?
        dest.save!
        puts "updated user #{dest.display_name}"
      end
    end
  end
end
