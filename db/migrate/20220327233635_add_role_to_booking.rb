class AddRoleToBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :event_bookings, :role, :string, default: 'attendee'
  end
end
