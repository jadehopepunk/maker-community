module Wp
  class MembershipPlan < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

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
          record.import_new unless dest_class.where(wordpress_post_id: record.ID).exists?
        end
      end
    end

    def import_new
      return if post_name == 'account-holder'

      dest = self.class.dest_class.new(
        title: TITLE_MAP[post_name] || post_title,
        name: post_name,
        created_at: post_date,
        position: PLAN_ORDER.index(post_name),
        wordpress_post_id: self.ID,
        wordpress_product_id: product_ids.first
      )
      dest.save!
      puts "Imported membership plan: #{dest.name}"
    end

    def product_ids
      return [] if meta_hash['_product_ids'].blank?

      PHP.unserialize meta_hash['_product_ids']
    end
  end
end
