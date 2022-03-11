class CreateUserInductions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_inductions do |t|
      t.references :user, foreign_key: true
      t.references :induction, foreign_key: true
      t.date :inducted_on
    end

    add_index :user_inductions, [:user_id, :induction_id], unique: true
  end
end
