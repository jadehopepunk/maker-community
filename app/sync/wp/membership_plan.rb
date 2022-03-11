module Wp
  class MembershipPlan < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    TITLE_MAP = {
      'makerspace-community-concession-member' => 'Community Concession Member',
      'makerspace-full-time-member' => 'Full-Time Member',
      'makerspace-community-member' => 'Community Member'
    }.freeze

    NAME_MAP = {
      'makerspace-community-concession-member' => 'community_concession_member',
      'makerspace-full-time-member' => 'full_time_member',
      'makerspace-community-member' => 'community_member'
    }.freeze

    PLAN_ORDER = ['association-member', 'makerspace-community-concession-member', 'makerspace-community-member',
                  'makerspace-full-time-member', 'volunteer', 'board-member']

    default_scope { where(post_type: 'wc_membership_plan') }

    class << self
      def dest_class
        ::Plan
      end

      def sync
        find_each(&:import_or_update)
      end
    end

    def import_new
      return if post_name == 'account-holder'

      dest = self.class.dest_class.new(
        **shared_attributes,
        created_at: post_date,
        wordpress_post_id: self.ID,
        wordpress_product_id: product_ids.first
      )
      dest.save!
      puts "Imported membership plan: #{dest.name}"
    end

    def shared_attributes
      {
        title: TITLE_MAP[post_name] || post_title,
        name: NAME_MAP[post_name] || post_name.underscore,
        position: PLAN_ORDER.index(post_name)
      }
    end

    def product_ids
      return [] if meta['_product_ids'].blank?

      PHP.unserialize meta['_product_ids']
    end

    def imported_record_key
      :wordpress_post_id
    end
  end
end
