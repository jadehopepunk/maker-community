module Wp
  class OrderItem < Wp::Base
    self.table_name = 'wp_woocommerce_order_items'

    has_many :order_item_meta, foreign_key: :order_item_id, class_name: 'Wp::OrderItemMeta'
    scope :with_meta, -> { includes(:order_item_meta) }

    def meta
      @meta ||= OrderItemMeta.convert_to_hash(order_item_meta)
    end

    def product_id
      meta['_product_id']&.to_i
    end

    def product_post
      raise "no product id for #{inspect}" unless product_id.present?

      Post.find(product_id).as_subclass
    end

    def build_new
      product = product_post.destination_record
      return nil if product.nil?

      ::OrderItem.new(
        product:,
        name: order_item_name,
        quantity: meta['_qty'],
        line_subtotal: meta['_line_subtotal'],
        line_subtotal_tax: meta['_line_subtotal_tax'],
        line_total: meta['_line_total'],
        line_tax: meta['_line_tax'],
        wordpress_id: order_item_id
      )
    end

    def import_new(order)
      dest = build_new
      return nil if dest.nil?

      dest.order = order
      dest.save!

      puts "imported order item #{order_item_name}"
      dest
    end
  end
end
