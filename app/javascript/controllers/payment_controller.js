import { Controller } from "@hotwired/stimulus";
import { initializeStripeForm } from "../lib/stripe_event_payment";

export default class extends Controller {
  connect() {
    console.log("connected");
    initializeStripeForm(this.clientSecret);
  }

  // PRIVATE

  get clientSecret() {
    return this.element.dataset.clientSecret;
  }
}
