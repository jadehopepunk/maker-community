class SessionsController < Devise::SessionsController
  def create
    if target_user&.password_imported?
      redirect_to new_user_password_path, alert: 'Your account was imported from the old website, and you need to set a new password. Please use this forgot password form.'
      return
    end
    super
  end

  private

  def target_user
    User.find_by_email(params[:user][:email])
  end
end
