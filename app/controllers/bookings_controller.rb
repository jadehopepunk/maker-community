class BookingsController < ApplicationController
  def new
    load_event_session
    load_existing_booking
    @order_form = new_order
    @order_form.event_session = @event_session
    store_location_for(:user, request.fullpath)
  end

  def create
    load_event_session
    load_existing_booking
    @order_form = new_order
    @order_form.attributes = order_params
    if @order_form.save
      if @order_form.order.completed?
        OrderService.new.fulfill_if_complete(@order_form.order)
        flash[:notice] = 'Your booking has been confirmed.'
        redirect_to event_path(@event_session)
      else
        redirect_to pay_order_path(@order_form.order)
      end
    else
      render template: 'bookings/new'
    end
  end

  private

  def new_order
    order = Forms::BookingOrder.new(event_session: @event_session, user: current_user)
    order.existing_booking = @existing_booking
    order
  end

  def load_event_session
    @event_session = EventSession.find(params[:event_id])
  end

  def load_existing_booking
    @existing_booking = @event_session.bookings.in_cart.find_by(user: current_user)
  end

  def order_params
    params.require(:order).permit(:email, :name, :comments, price_orders_attributes: [:price_id, :persons])
  end
end
