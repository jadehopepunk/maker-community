class CreateUserEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :user_events do |t|
      t.references :user, foreign_key: true
      t.string :type
      t.references :subject, polymorphic: true
      t.datetime :occured_at
    end
  end
end
