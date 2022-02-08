module Wp
  class OrderItemMeta < Wp::Base
    self.table_name = 'wp_woocommerce_order_itemmeta'

    class << self
      def convert_to_hash(records)
        records.map do |record|
          [record.meta_key, record.meta_value]
        end.to_h
      end
    end
  end
end
