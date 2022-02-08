module Wp
  class OrderItem < Wp::Base
    self.table_name = 'wp_woocommerce_order_items'

    has_many :order_item_meta, foreign_key: :order_item_id, class_name: 'Wp::OrderItemMeta'
    scope :with_meta, -> { includes(:order_item_meta) }

    def meta_hash
      @meta ||= OrderItemMeta.convert_to_hash(order_item_meta)
    end

    def product_id
      meta_hash['_product_id']&.to_i
    end

    def product_post
      raise "no product id for #{inspect}" unless product_id.present?

      Post.find(product_id).as_subclass
    end

    def import_new(_order)
      # puts "Product post is #{product_post.inspect}"
      # dest = ::OrderItem.create!(
      #   order:,
      #   product:,
      #   name: order_item_name,
      #   quantity: meta_hash['_qty'],
      #   line_subtotal: meta_hash['_line_subtotal'],
      #   line_subtotal_tax: meta_hash['_line_subtotal_tax'],
      #   line_total: meta_hash['_line_total'],
      #   line_tax: meta_hash['_line_tax'],
      #   wordpress_id: self.ID
      # )

      # puts "imported order item #{order_item_name}"
      # dest
    end
  end
end
