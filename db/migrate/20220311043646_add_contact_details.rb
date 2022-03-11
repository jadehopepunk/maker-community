class AddContactDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :postcode
      t.string :country_code

      t.timestamps
    end

    add_column :users, :address_id, :integer
    add_column :users, :phone, :string
    add_foreign_key :users, :addresses, column: :address_id
  end
end
