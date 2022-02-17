class EventsController < ApplicationController
  def index
    @event_sessions = EventSession.from_this_week.page(params[:page]).per(20)
  end

  def show; end
end
