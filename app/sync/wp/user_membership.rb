module Wp
  class UserMembership < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::HasPostMeta

    default_scope { where(post_type: 'wc_user_membership') }

    class << self
      def dest_class
        ::Membership
      end

      def sync
        find_each do |record|
          import_new(record) unless dest_class.where(wordpress_post_id: record.ID).exists?
        end
      end

      def import_new(record)
        meta = record.post_meta_hash
        user = ::User.where(wordpress_id: record.post_author.to_i).first
        membership_plan = ::MembershipPlan.where(wordpress_post_id: record.post_parent.to_i).first
        subscription = ::Subscription.where(wordpress_post_id: meta['_subscription_id']).first

        return unless user && membership_plan

        dest = dest_class.new(
          user:,
          membership_plan:,
          subscription:,
          created_at: record.post_date,
          status: record.post_status&.sub(/^wcm-/, ''),
          wordpress_post_id: record.ID,
          start_at: meta['_start_date'],
          end_at: meta['_end_date']
        )
        dest.save!
        puts "Imported membership: #{user.display_name}, #{membership_plan.name}, #{dest.status}"
      end
    end
  end
end
