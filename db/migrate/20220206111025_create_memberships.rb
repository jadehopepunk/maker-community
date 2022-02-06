class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.string :status
      t.belongs_to :user, foreign_key: true
      t.belongs_to :membership_plan, foreign_key: true
      t.belongs_to :subscription, foreign_key: true
      t.integer :wordpress_post_id
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
