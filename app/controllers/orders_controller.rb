class OrdersController < ApplicationController
  def pay
    @order = Order.find(params[:id])

    if @order.free? || @order.completed? || @order.payment_intent['status'] == 'succeeded'
      complete_order
      fulfill_order
    else
      @client_secret = @order.payment_intent['client_secret']
      @return_url = pay_order_url(@order)
      render :pay
    end
  end

  private

  def complete_order
    @order.complete! unless @order.completed?
  end

  def fulfill_order
    result = OrderService.new.fulfill_if_complete(@order)
    redirect_to_product(result.first)
  end

  def redirect_to_product(product)
    if product.is_a?(EventBooking)
      flash[:success] = 'Booking complete'
      redirect_to event_path(product.session)
    else
      redirect_to '/'
    end
  end
end

# Payment intent status are:
# requires_payment_method, requires_confirmation, requires_action, processing, requires_capture, canceled, or succeeded.
