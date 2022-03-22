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
        find_each(&:import_or_update)
      end
    end

    def import_new
      user = ::User.where(wordpress_id: post_author.to_i).first
      plan = ::Plan.where(wordpress_post_id: post_parent.to_i).first
      subscription = ::Subscription.where(wordpress_post_id: meta['_subscription_id']).first

      return unless user && plan

      props = {
        user:,
        plan:,
        subscription:,
        start_at: meta['_start_date'],
        **shared_attributes,
        created_at: post_date,
        wordpress_post_id: self.ID
      }
      dest = MembershipService.create(props)

      puts "Imported membership: #{user.display_name}, #{plan.name}, #{dest.status}"
    end

    def shared_attributes
      {
        status: post_status&.sub(/^wcm-/, ''),
        end_at: meta['_end_date']
      }
    end

    def update_existing
      dest = existing_dest

      dest.assign_attributes shared_attributes
      save_changes(dest) if dest.changed?
    end

    def save_changes(dest)
      dest.changes.each do |key, values|
        send("save_#{key}".to_sym, *values)
      end
    end

    def save_end_at(old_value, new_value)
      if old_value.present? && new_value.present?
        difference = (new_value - old_value).to_i
        if difference.abs < 24.hours
          update_end_at_value(new_value)
          puts "User membership #{self.ID} - updated time difference for end at: #{difference / 1.hour.to_f} hours"
          return
        end
      end

      update_end_at_value(new_value)
      puts "User membership #{self.ID} - updated from #{old_value.inspect} to #{new_value.inspect}"
    end

    def update_end_at_value(new_value)
      find_existing_dest.update!(end_at: new_value)
    end

    def save_status(old_value, new_value)
      puts "saving status because of change #{old_value} -> #{new_value}"
    end

    def imported_record_key
      :wordpress_post_id
    end
  end
end
