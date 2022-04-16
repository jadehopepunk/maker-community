class BookingsController < ApplicationController
  def new
    load_event_session
    @order = new_order
    @order.event_session = @event_session
    store_location_for(:user, request.fullpath)
  end

  def create
    load_event_session
    @order = new_order
    @order.attributes = order_params
    @order.valid?
    render template: 'bookings/new'
  end

  private

  def new_order
    Forms::BookingOrder.new(event_session: @event_session, user: current_user)
  end

  def load_event_session
    @event_session = EventSession.find(params[:event_id])
  end

  def order_params
    params.require(:order).permit(:email, price_orders_attributes: [:price_id, :persons])
  end
end
