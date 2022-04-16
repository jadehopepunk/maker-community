class BookingsController < ApplicationController
  def new
    load_event_session
    @order = Forms::BookingOrder.new
  end

  def create
    load_event_session
    @order = Forms::BookingOrder.new(params.require(:order).permit(:email))
    @order.valid?
    render template: 'bookings/new'
  end

  private

  def load_event_session
    @event_session = EventSession.find(params[:event_id])
  end
end
