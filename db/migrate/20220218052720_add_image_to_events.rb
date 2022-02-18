class AddImageToEvents < ActiveRecord::Migration[7.0]
  def change
    add_reference :events, :image, foreign_key: true
  end
end
