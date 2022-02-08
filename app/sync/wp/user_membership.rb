module Wp
  class UserMembership < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    default_scope { where(post_type: 'wc_user_membership') }

    class << self
      def dest_class
        ::Membership
      end

      def sync
        find_each do |record|
          record.import_new unless dest_class.where(wordpress_post_id: record.ID).exists?
        end
      end
    end

    def import_new
      meta = meta_hash
      user = ::User.where(wordpress_id: post_author.to_i).first
      plan = ::Plan.where(wordpress_post_id: post_parent.to_i).first
      subscription = ::Subscription.where(wordpress_post_id: meta['_subscription_id']).first

      return unless user && plan

      props = {
        user:,
        plan:,
        subscription:,
        created_at: post_date,
        status: post_status&.sub(/^wcm-/, ''),
        wordpress_post_id: self.ID,
        start_at: meta['_start_date'],
        end_at: meta['_end_date']
      }
      dest = MembershipService.create(props)

      puts "Imported membership: #{user.display_name}, #{plan.name}, #{dest.status}"
    end
  end
end
