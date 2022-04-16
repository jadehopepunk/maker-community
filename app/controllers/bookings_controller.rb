class BookingsController < ApplicationController
  def new
    load_event_session
    @order = Forms::BookingOrder.new
    @order.event_session = @event_session
    store_location_for(:user, request.fullpath)
  end

  def create
    load_event_session
    @order = Forms::BookingOrder.new(event_session: @event_session)
    @order.attributes = order_params
    @order.valid?
    render template: 'bookings/new'
  end

  private

  def load_event_session
    @event_session = EventSession.find(params[:event_id])
  end

  def order_params
    params.require(:order).permit(:email, price_orders_attributes: [:price_id, :persons])
  end
end
