module Wp
  class Post < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    POST_TYPES = {
      shop_order: Wp::ShopOrder,
      shop_subscription: Wp::ShopSubscription,
      wc_membership_plan: Wp::MembershipPlan,
      wc_user_membership: Wp::UserMembership,
      product: Wp::Product,
      attachment: Wp::Attachment,
      bookable_person: Wp::BookablePerson
    }

    def as_subclass
      klass = POST_TYPES[post_type.to_sym]
      raise "Unknown post type: #{post_type} for post ID #{self.ID}" unless klass

      klass.find(self.ID)
    end
  end
end
