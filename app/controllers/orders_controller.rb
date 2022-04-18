class OrdersController < ApplicationController
  def pay
    @order = Order.find(params[:id])
    @client_secret = @order.payment_intent_client_secret
    @return_url = stripe_return_order_url(@order)
  end

  def stripe_return
    render json: { status: 'success' }
  end
end
