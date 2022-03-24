class AddTypeToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :type, :string, default: 'Events::SimpleEvent'
  end
end
