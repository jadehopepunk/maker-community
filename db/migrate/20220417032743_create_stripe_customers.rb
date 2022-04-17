class CreateStripeCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :stripe_customers do |t|
      t.belongs_to :user, foreign_key: true, unique: true
      t.string :stripe_customer_id
      t.timestamps
    end

    add_index :stripe_customers, :user_id, unique: true, name: 'customer_unique_user_id'
  end
end
