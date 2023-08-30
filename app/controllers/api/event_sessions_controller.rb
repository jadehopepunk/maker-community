module Api
  class EventSessionsController < ApplicationController
    def next
      @event_session = EventSession.today.first || EventSession.future.date_order.first
      render json: @event_session.as_json(
        only: [:id, :start_at, :end_at, :max_persons],
        include: {
          event: {
            only: [:id, :slug, :title]
          },
          manager_bookings: {
            only: [:id, :role],
            include: {
              user: {
                only: [:id, :display_name]
              }
            }
          }
        }
      )
    end
  end
end
