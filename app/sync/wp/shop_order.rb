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
        with_meta.includes(:order_items).find_each do |record|
          record.import_new unless dest_class.where(wordpress_post_id: record.ID).exists?
        end
      end
    end

    def import_new
      meta = meta_hash
      user_id = meta['_customer_user'].to_i

      if user_id == 0
        puts "skipping ShopOrder ##{self.ID} because it has no customer id"
        return
      end

      user = ::User.where(wordpress_id: user_id).first

      dest = self.class.dest_class.new(
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
        wordpress_post_id: self.ID
      )
      dest.save!
      import_new_order_items(dest)
      puts "Imported order: #{self.ID}"
    end

    def import_new_order_items(dest)
      scope = order_items.where.not(order_item_type: %w[tax coupon shipping]).with_meta
      scope.each do |order_item|
        order_item.import_new(dest)
      end
    end
  end
end
