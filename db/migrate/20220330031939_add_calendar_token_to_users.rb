class AddCalendarTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :calendar_token, :uuid, default: "gen_random_uuid()"
  end
end
