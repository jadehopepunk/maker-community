class CreateAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :availabilities do |t|
      t.belongs_to :user
      t.belongs_to :event_session
      t.string :status
      t.timestamps
    end
  end
end
