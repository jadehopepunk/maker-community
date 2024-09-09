class CreateFobSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :fob_sessions do |t|
      t.belongs_to :fob, null: false, foreign_key: true
      t.timestamp :opened_at, null: false
      t.timestamp :closed_at, null: true
      t.boolean :auto_closed, null: false, default: false
    end
  end
end
