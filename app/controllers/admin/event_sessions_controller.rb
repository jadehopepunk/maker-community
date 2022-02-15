module Admin
  class EventSessionsController < AdminController
    def show
      @event_session = EventSession.find params[:id]

      @q = @event_session.bookings.includes(:user).ransack(params[:q])
      @q.sorts = ['users_display_name asc'] if @q.sorts.empty?
      @bookings = @q.result.page(params[:page]).per(20)
    end
  end
end
