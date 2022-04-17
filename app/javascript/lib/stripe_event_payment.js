const STRIPE_PUBLISHABLE_KEY = "pk_live_vSO1kxFr4mPCKiMs2biEX2iA00clvbvfOp";
const stripe = Stripe(STRIPE_PUBLISHABLE_KEY);

async function initializeStripeForm(cost) {
  const response = await fetch("create_payment_intent", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ cost }),
  });
  const { clientSecret } = await response.json();

  const appearance = {
    theme: "stripe",
  };
  elements = stripe.elements({ appearance, clientSecret });

  const paymentElement = elements.create("payment");
  paymentElement.mount("#payment-element");
}

export { initializeStripeForm };
