module Wp
  class Base < ActiveRecord::Base
    self.abstract_class = true

    connects_to database: { writing: :wordpress, reading: :wordpress }

    class << self
      def sync
        User.sync
        MembershipPlan.sync
        ShopSubscription.sync
        UserMembership.sync
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
  end
end
