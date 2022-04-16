class BookingsController < ApplicationController
  class BookingOrder
    include ActiveModel::Model

    attr_accessor :email

    validates :email, presence: true
  end

  def new
    load_event_session
    @order = BookingOrder.new
  end

  def create
    load_event_session
    @order = BookingOrder.new(params[:order].permit(:email))
    render :new and return unless @order.valid?
  end

  private

  def load_event_session
    @event_session = EventSession.find(params[:event_id])
  end
end
