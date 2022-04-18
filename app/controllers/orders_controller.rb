class OrdersController < ApplicationController
  def pay
    @order = Order.find(params[:id])
    payment_intent = @order.payment_intent
    @client_secret = payment_intent['client_secret']
    @return_url = pay_order_url(@order)

    if payment_intent['status'] == 'succeeded'
      fulfill_order
    else
      render :pay
    end
  end

  private

  def fulfill_order
    raise 'fulfill order'
  end
end

# Payment intent status are:
# requires_payment_method, requires_confirmation, requires_action, processing, requires_capture, canceled, or succeeded.
