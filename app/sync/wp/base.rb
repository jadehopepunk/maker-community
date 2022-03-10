module Wp
  class Base < ActiveRecord::Base
    self.abstract_class = true

    connects_to database: { writing: :wordpress, reading: :wordpress }

    class << self
      def sync
        Wp::User.sync
        Wp::MembershipPlan.sync
        Wp::Event.sync
        Wp::ShopSubscription.sync
        Wp::UserMembership.sync
        Wp::ShopOrder.sync
        Wp::Booking.sync
        Import.record.update!(imported_at: Time.now)
      end

      def add_roles
        craig = ::User.find_by_email('craig@craigambrose.com')
        craig.add_role :people_admin
      end

      def clear_passwords
        ::User.where(email: ['craig@craigambrose.com']).each do |user|
          user.password = 'password'
          user.save!
        end
      end
    end

    def import_if_new
      import_new unless dest_class.where(imported_record_key => primary_key).exists?
    end

    def import_or_update
      if existing_dest
        update_existing
      else
        import_new
      end
    end

    def existing_dest
      @dest ||= dest_class.where(imported_record_key => primary_key).first
    end

    private

    def dest_class
      self.class.dest_class
    end

    def imported_record_key
      :wordpress_id
    end

    def primary_key
      self.ID
    end
  end
end
