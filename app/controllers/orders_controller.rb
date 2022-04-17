class OrdersController < ApplicationController
  def pay
    @order = Order.find(params[:id])

    payment_intent = Stripe::PaymentIntent.create(
      amount: @order.total_price_cents,
      currency: 'aud',
      payment_method_types: ['card']
    )

    @client_secret = payment_intent['client_secret']
  end
end
