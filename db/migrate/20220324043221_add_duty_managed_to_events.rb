class AddDutyManagedToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :duty_managed, :boolean, default: false
  end
end
