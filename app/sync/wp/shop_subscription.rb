module Wp
  class ShopSubscription < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    has_many :order_items, foreign_key: :order_id, class_name: 'Wp::OrderItem'

    default_scope { where(post_type: 'shop_subscription') }

    class << self
      def dest_class
        ::Subscription
      end

      def sync
        find_each do |record|
          record.import_new unless dest_class.where(wordpress_post_id: record.ID).exists?
        end
      end
    end

    def import_new
      user = ::User.where(wordpress_id: meta['_customer_user'].to_i).first

      dest = self.class.dest_class.new(
        user:,
        created_at: post_date,
        stripe_source_id: meta['_stripe_source_id'],
        stripe_customer_id: meta['_stripe_customer_id'],
        order_total: meta['_order_total'],
        order_tax: meta['_order_tax'],
        order_currency: meta['_order_currency'],
        payment_method_title: meta['_payment_method_title'],
        payment_method: meta['_payment_method'],
        wordpress_post_id: self.ID
      )
      dest.save!
      puts "Imported subscription: #{self.ID}"
    rescue ActiveRecord::RecordInvalid => e
      puts "Failed to import subscription: #{self.ID} - #{e.message}"
    end
  end
end
