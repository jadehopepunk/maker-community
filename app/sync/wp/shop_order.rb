module Wp
  class ShopOrder < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    has_many :order_items, foreign_key: :order_id, class_name: 'Wp::OrderItem'

    default_scope { where(post_type: 'shop_order') }

    class << self
      def dest_class
        ::Order
      end

      def sync
        with_meta.where(post_status: 'wc-completed').includes(:order_items).find_each do |record|
          record.import_new unless dest_class.where(wordpress_post_id: record.ID).exists?
        end
      end
    end

    def import_new
      dest = build_new
      return if dest.nil?

      OrderService.new.create(dest)

      puts "Imported order: #{self.ID}"
    end

    def build_new
      user = imported_customer

      return nil if user.nil?

      puts "importing order #{self.ID}"

      self.class.dest_class.new(
        user:,
        created_at: post_date,
        stripe_source_id: meta['_stripe_source_id'],
        stripe_customer_id: meta['_stripe_customer_id'],
        order_total: meta['_order_total'],
        order_tax: meta['_order_tax'],
        order_currency: meta['_order_currency'],
        payment_method: meta['_payment_method'],
        payment_method_title: meta['_payment_method_title'],
        paid_at: meta['_paid_date'],
        completed_at: meta['_completed_date'],
        wordpress_post_id: self.ID,
        status: post_status&.sub('wc-', ''),
        order_items: build_order_items
      )
    end

    def build_order_items
      scope = order_items.where.not(order_item_type: %w[tax coupon shipping]).with_meta
      scope.map do |order_item|
        order_item.build_new
      end.compact
    end

    def imported_customer
      return nil if customer_id.nil?

      user = ::User.where(wordpress_id: customer_id).first
      raise "No user for customer #{meta['_customer_user']} on order #{self.ID}" if user.nil?

      user
    end

    def customer_id
      result = meta['_customer_user']&.to_i
      result == 0 ? nil : result
    end
  end
end
