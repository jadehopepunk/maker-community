class AddNotNullConstraintToPersons < ActiveRecord::Migration[7.0]
  def up
    EventBooking.where(persons: nil).update_all(persons: 1)
    change_column_null :event_bookings, :persons, false
  end

  def down
    change_column_null :event_bookings, :persons, true
  end
end
