class ChangeImagesKey < ActiveRecord::Migration[7.0]
  def up
    rename_column :images, :wordpress_post_id, :old_wordpress_post_id
    add_column :images, :wordpress_post_id, :integer
    execute "UPDATE images SET wordpress_post_id = to_number(old_wordpress_post_id,'9999999')"
    remove_column :images, :old_wordpress_post_id
    add_index :images, :wordpress_post_id, unique: true
  end

  def down
    remove_index :images, :wordpress_post_id, unique: true
    rename_column :images, :wordpress_post_id, :old_wordpress_post_id
    add_column :images, :wordpress_post_id, :string
    execute "UPDATE images SET wordpress_post_id = old_wordpress_post_id"
    remove_column :images, :old_wordpress_post_id
  end
end
