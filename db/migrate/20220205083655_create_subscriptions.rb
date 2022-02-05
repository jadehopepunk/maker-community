class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, foreign_key: true
      t.string :stripe_source_id
      t.string :stripe_customer_id
      t.decimal :order_total, precision: 8, scale: 2
      t.decimal :order_tax, precision: 8, scale: 2
      t.string :order_currency
      t.string :payment_method_title
      t.string :payment_method
      t.integer :wordpress_post_id
      t.timestamps
    end
  end
end
