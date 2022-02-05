class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    if current_user
      flash[:alert] = 'Sorry, you are not authorized to perform this action.'
      redirect_to(request.referrer || root_path)
    else
      flash[:alert] = 'You must be logged in to perform this action.'
      store_location_for(:user, request.fullpath) if storable_location?
      redirect_to(new_user_session_path)
    end
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def after_sign_in_path_for(_resource_or_scope)
    stored_location_for(:user) || root_path
  end
end
