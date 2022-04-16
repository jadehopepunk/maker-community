class BookingsController < ApplicationController
  def new
    @event_session = EventSession.find(params[:event_id])
  end
end
