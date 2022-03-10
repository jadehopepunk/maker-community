class CreateImports < ActiveRecord::Migration[7.0]
  def change
    create_table :imports do |t|
      t.datetime :imported_at
    end
  end
end
