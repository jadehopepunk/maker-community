module Wp
  class MembershipPlan < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::HasPostMeta

    default_scope { where(post_type: 'wc_membership_plan') }

    class << self
      def dest_class
        ::MembershipPlan
      end

      def sync
        find_each do |record|
          import_new(record) unless dest_class.where(wordpress_post_id: record.ID).exists?
        end
      end

      def import_new(record)
        return if record.post_name == 'account-holder'

        dest = dest_class.new(
          title: record.post_title,
          name: record.post_name,
          created_at: record.post_date,
          wordpress_post_id: record.ID
        )
        dest.save!
        puts "Imported membership plan: #{dest.name}"
      end
    end
  end
end
