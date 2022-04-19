class PeopleController < ApplicationController
  def me
    @user = current_user
    @memberships = current_user.memberships.includes(:plan)
    @bookings = current_user.bookings.includes(session: :event).future.session_date_order
  end
end
