module Wp
  class MembershipPlan < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::HasPostMeta

    TITLE_MAP = {
      'makerspace-community-concession-member' => 'Community Concession Member',
      'makerspace-full-time-member' => 'Full-Time Member',
      'makerspace-community-member' => 'Community Member'
    }.freeze

    PLAN_ORDER = %w[
      association-member
      makerspace-community-concession-member
      makerspace-community-member
      makerspace-full-time-member
      volunteer
      board-member
    ]

    default_scope { where(post_type: 'wc_membership_plan') }

    class << self
      def dest_class
        ::Plan
      end

      def sync
        find_each do |record|
          import_new(record) unless dest_class.where(wordpress_post_id: record.ID).exists?
        end
      end

      def import_new(record)
        return if record.post_name == 'account-holder'

        dest = dest_class.new(
          title: TITLE_MAP[record.post_name] || record.post_title,
          name: record.post_name,
          created_at: record.post_date,
          position: PLAN_ORDER.index(record.post_name),
          wordpress_post_id: record.ID
        )
        dest.save!
        puts "Imported membership plan: #{dest.name}"
      end
    end
  end
end
