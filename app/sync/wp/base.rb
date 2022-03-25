module Wp
  class Base < ActiveRecord::Base
    self.abstract_class = true

    connects_to database: { writing: :wordpress, reading: :wordpress }

    class << self
      def sync
        puts 'IMPORTING USERS'
        Wp::User.sync
        puts 'IMPORTING PLANS'
        Wp::MembershipPlan.sync
        puts 'IMPORTING EVENTS'
        Wp::Event.sync
        puts 'IMPORTING SUBSCRIPTIONS'
        Wp::ShopSubscription.sync
        puts 'IMPORTING MEMBERSHIPS'
        Wp::UserMembership.sync
        puts 'IMPORTING ORDERS'
        Wp::ShopOrder.sync
        puts 'IMPORTING BOOKINGS'
        Wp::Booking.sync
        Import.record.update!(imported_at: Time.now)
        puts 'DONE'
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
      @dest ||= find_existing_dest
    end

    def find_existing_dest
      dest_class.where(imported_record_key => primary_key).first
    end

    def update_existing
      dest = existing_dest

      dest.assign_attributes shared_attributes
      if dest.changed?
        dest.save!
        puts "updated #{self.class.name}: #{dest.title}"
      end
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
