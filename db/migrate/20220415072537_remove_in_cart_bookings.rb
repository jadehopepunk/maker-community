class RemoveInCartBookings < ActiveRecord::Migration[7.0]
  def up
    EventBooking.where(status: 'in-cart').delete_all
  end

  def down
  end
end
