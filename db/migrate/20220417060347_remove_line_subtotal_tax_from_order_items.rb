class RemoveLineSubtotalTaxFromOrderItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :order_items, :line_subtotal_tax, :decimal, precision: 10, scale: 2
  end
end
