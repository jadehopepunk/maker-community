class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.string :status
      t.string :stripe_customer_id
      t.string :stripe_source_id
      t.string :payment_method
      t.string :payment_method_title
      t.decimal :order_total, precision: 8, scale: 2
      t.decimal :order_tax, precision: 8, scale: 2
      t.string :order_currency
      t.datetime :paid_at
      t.datetime :completed_at
      t.string :wordpress_post_id
      t.timestamps
    end

    add_index :orders, :wordpress_post_id, unique: true
    add_index :memberships, :wordpress_post_id, unique: true
    add_index :plans, :wordpress_post_id, unique: true
    add_index :subscriptions, :wordpress_post_id, unique: true
    add_index :users, :wordpress_id, unique: true
  end
end
