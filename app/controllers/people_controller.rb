class PeopleController < ApplicationController
  def me
    return redirect_to(root_path) unless current_user.present?

    @user = current_user
    @memberships = current_user.memberships.includes(:plan)
    @bookings = current_user.bookings.includes(session: :event).future.session_date_order
  end

  def duty_manager; end
end
