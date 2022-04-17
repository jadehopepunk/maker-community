class AddSignUpStatusToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :sign_up_status, :string, default: 'full', allow_nil: false
    change_column_null :users, :encrypted_password, true
    change_column_default :users, :encrypted_password, nil
    User.update_all(sign_up_status: 'imported', encrypted_password: nil)
  end

  def down
    remove_column :users, :sign_up_status
    change_column_null :users, :encrypted_password, false
  end
end
