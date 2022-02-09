class CreateEventSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :event_sessions do |t|
      t.references :event, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
    end
  end
end
