class CreateSlackUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :slack_users do |t|
      t.string :slack_user_id
      t.string :team_id
      t.string :name
      t.string :display_name
      t.string :image_48
      t.string :image_512
      t.belongs_to :user, index: true, foreign_key: true, unique: true
      t.timestamps
    end
  end
end
