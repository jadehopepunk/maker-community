class CreateEventBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :event_bookings do |t|
      t.references :event_session, foreign_key: true
      t.references :user, foreign_key: true
      t.references :order_item, optional: true, foreign_key: true
      t.integer :persons, default: 1
      t.integer :wordpress_post_id
      t.timestamps
    end
  end
end
