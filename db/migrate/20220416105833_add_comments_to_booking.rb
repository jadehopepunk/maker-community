class AddCommentsToBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :event_bookings, :comments, :text
  end
end
