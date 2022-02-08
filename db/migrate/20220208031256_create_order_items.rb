class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.references :order, foreign_key: true
      t.references :product, polymorphic: true
      t.string :name
      t.integer :quantity
      t.decimal :line_subtotal, precision: 10, scale: 2
      t.decimal :line_subtotal_tax, precision: 10, scale: 2
      t.decimal :line_total, precision: 10, scale: 2
      t.decimal :line_tax, precision: 10, scale: 2
      t.integer :wordpress_id
    end
  end
end
