module Admin
  class EventSessionsController < AdminController
    def show
      @event_session = EventSession.find params[:id]
    end
  end
end
