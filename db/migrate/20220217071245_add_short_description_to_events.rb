class AddShortDescriptionToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :short_description, :string
  end
end
