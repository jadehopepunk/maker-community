class PasswordsController < Devise::PasswordsController
  # PUT /resource/password
  def update
    super do |user|
      user.update(sign_up_status: 'full')
    end
  end
end
