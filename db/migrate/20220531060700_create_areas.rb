class CreateAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :areas do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.belongs_to :image, foreign_key: true
      t.timestamps
    end
  end
end
