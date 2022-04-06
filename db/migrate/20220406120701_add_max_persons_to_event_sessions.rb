class AddMaxPersonsToEventSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :event_sessions, :max_persons, :int, default: nil
  end
end
