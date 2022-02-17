class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :wordpress_post_id
      t.string :alt_text
      t.string :caption
      t.timestamps
    end
  end
end
