const STRIPE_PUBLISHABLE_KEY = "pk_live_vSO1kxFr4mPCKiMs2biEX2iA00clvbvfOp";
const stripe = Stripe(STRIPE_PUBLISHABLE_KEY);

async function initializeStripeForm(clientSecret) {
  const appearance = { theme: "stripe" };
  elements = stripe.elements({ appearance, clientSecret });

  const paymentElement = elements.create("payment");
  paymentElement.mount("#payment-element");
}

export { initializeStripeForm, stripe };
