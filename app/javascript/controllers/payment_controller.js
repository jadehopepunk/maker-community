import { Controller } from "@hotwired/stimulus";
import { initializeStripeForm } from "../lib/stripe_event_payment";

export default class extends Controller {
  static targets = ["submit"];

  connect() {
    console.log("connected");
    initializeStripeForm(this.clientSecret);
    this.element.addEventListener("submit", this.handleSubmit.bind(this));
  }

  handleSubmit(event) {
    event.preventDefault();
    this.setLoading(true);
    console.log("handling submit");
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

  // PRIVATE

  get clientSecret() {
    return this.element.dataset.clientSecret;
  }
}
