module Api
  class EventSessionsController < ApplicationController
    def next
      @event_session = EventSession.today.first || EventSession.future.date_order.first
      render json: @event_session.as_json(
        include: [:event, :manager_bookings]
      )
    end
  end
end
