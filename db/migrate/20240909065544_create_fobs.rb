class CreateFobs < ActiveRecord::Migration[7.2]
  def change
    create_table :fobs do |t|
      t.belongs_to :user, null: true, foreign_key: true
      t.string :device_id, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
