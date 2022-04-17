class BookingsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create_payment_intent

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
    if @order.save
      redirect_to event_path(@event_session), notice: 'Booking was successfully created.'
    else
      render template: 'bookings/new'
    end
  end

  def create_payment_intent
    payment_intent = Stripe::PaymentIntent.create(
      amount: 500,
      currency: 'aud',
      payment_method_types: ['card']
    )

    render json: { clientSecret: payment_intent['client_secret'] }.to_json
  end

  private

  def new_order
    Forms::BookingOrder.new(event_session: @event_session, user: current_user)
  end

  def load_event_session
    @event_session = EventSession.find(params[:event_id])
  end

  def order_params
    params.require(:order).permit(:email, :name, :comments, price_orders_attributes: [:price_id, :persons])
  end
end
