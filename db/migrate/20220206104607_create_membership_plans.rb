class CreateMembershipPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :membership_plans do |t|
      t.string :title
      t.string :name
      t.integer :wordpress_post_id
      t.timestamps
    end
  end
end
