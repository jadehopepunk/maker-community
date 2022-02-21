class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :title
      t.string :slug
      t.integer :wordpress_term_id
      t.timestamps
      t.index [ :wordpress_term_id ], unique: true
    end

    create_table :taggings do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :taggable, polymorphic: true, index: true
      t.datetime :created_at
    end
  end
end
