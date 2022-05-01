class ChangeCalendarTokenDefinition < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :calendar_token, :uuid, allow_nil: true, default: nil
  end

  def down
  end
end
