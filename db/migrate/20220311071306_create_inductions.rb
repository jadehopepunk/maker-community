class CreateInductions < ActiveRecord::Migration[7.0]
  def change
    create_table :inductions do |t|
      t.string :title
      t.timestamps
    end

    add_index :inductions, :title, unique: true
  end
end
