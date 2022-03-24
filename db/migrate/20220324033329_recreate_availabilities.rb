class RecreateAvailabilities < ActiveRecord::Migration[7.0]
  def up
    drop_table :availabilities

    create_table :availabilities do |t|
      t.belongs_to :user
      t.belongs_to :event_session
      t.belongs_to :creator, foreign_key: { to_table: :users }
      t.string :status
      t.timestamps
    end
  end

  def down
  end
end
