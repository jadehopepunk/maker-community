class RenameBookingStatus < ActiveRecord::Migration[7.0]
  def up
    EventBooking.where(status: ['complete', 'paid']).update_all(status: 'active')
  end
end
