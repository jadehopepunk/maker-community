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
    end
  end
end
