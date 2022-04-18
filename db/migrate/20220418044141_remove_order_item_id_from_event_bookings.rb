class RemoveOrderItemIdFromEventBookings < ActiveRecord::Migration[7.0]
  def change
    remove_reference :event_bookings, :order_item, index: true, foreign_key: true
  end
end
