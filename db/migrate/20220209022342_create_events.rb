class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :author, index: true, foreign_key: { to_table: :users }
      t.string :slug
      t.string :title
      t.string :content
      t.integer :wordpress_post_id
      t.timestamps
    end
  end
end
