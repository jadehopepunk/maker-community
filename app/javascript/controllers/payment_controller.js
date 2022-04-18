import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["submit", "actions"];

  connect() {
    console.log("connected");
    this.stripe = Stripe(this.element.dataset.publishableKey);
    this.initializeStripeForm();
    this.checkStatus();
    this.element.addEventListener("submit", this.handleSubmit.bind(this));
  }

  async handleSubmit(event) {
    event.preventDefault();
    this.setLoading(true);

    const { error } = await this.stripe.confirmPayment({
      elements: this.elements,
      confirmParams: {
        return_url: this.returnUrl,
      },
    });

    // This point will only be reached if there is an immediate error when
    // confirming the payment. Otherwise, your customer will be redirected to
    // your `return_url`. For some payment methods like iDEAL, your customer will
    // be redirected to an intermediate site first to authorize the payment, then
    // redirected to the `return_url`.
    if (error.type === "card_error" || error.type === "validation_error") {
      this.showMessage(error.message, "bad");
    } else {
      this.showMessage("An unexpected error occured.", "bad");
    }

    this.setLoading(false);
  }

  setLoading(isLoading) {
    if (isLoading) {
      // Disable the button and show a spinner
      this.element.querySelector("#submit").disabled = true;
      this.element.querySelector("#spinner").classList.remove("hidden");
      this.element.querySelector("#button-text").classList.add("hidden");
    } else {
      this.element.querySelector("#submit").disabled = false;
      this.element.querySelector("#spinner").classList.add("hidden");
      this.element.querySelector("#button-text").classList.remove("hidden");
    }
  }

  showMessage(messageText, quality) {
    const messageContainer = this.element.querySelector("#payment-message");

    messageContainer.classList.remove("hidden");
    messageContainer.classList.remove("good");
    messageContainer.classList.remove("neutral");
    messageContainer.classList.remove("bad");
    messageContainer.classList.add(quality);
    messageContainer.textContent = messageText;

    setTimeout(function () {
      messageContainer.classList.add("hidden");
      messageContainer.textContent = "";
    }, 4000);
  }

  async initializeStripeForm() {
    const appearance = { theme: "stripe" };
    this.elements = this.stripe.elements({ appearance, clientSecret: this.clientSecret });

    const paymentElement = this.elements.create("payment");
    paymentElement.mount("#payment-element");
    this.actionsTarget.classList.remove("hidden");
  }

  // Fetches the payment intent status after payment submission
  async checkStatus() {
    const clientSecret = this.clientSecret;

    if (!clientSecret) {
      return;
    }

    const { paymentIntent } = await this.stripe.retrievePaymentIntent(clientSecret);

    switch (paymentIntent.status) {
      case "succeeded":
        this.showMessage("Payment succeeded!", "good");
        break;
      case "processing":
        this.showMessage("Your payment is processing.", "neutral");
        break;
      case "requires_payment_method":
        this.showMessage("Your payment was not successful, please try again.", "bad");
        break;
      default:
        this.showMessage("Something went wrong.", "bad");
        break;
    }
  }

  // PRIVATE

  get returnUrl() {
    return this.element.dataset.returnUrl;
  }

  get clientSecret() {
    return this.element.dataset.clientSecret;
  }
}
