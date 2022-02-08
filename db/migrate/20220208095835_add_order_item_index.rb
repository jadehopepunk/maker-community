class AddOrderItemIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :order_items, :wordpress_id, unique: true
  end
end
