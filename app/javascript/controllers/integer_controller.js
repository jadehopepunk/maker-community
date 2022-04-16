import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    console.log("connected", this.element);
  }

  decrement(event) {
    event.preventDefault();
    this.inputTarget.value = parseInt(this.inputTarget.value) - 1;
  }

  increment(event) {
    event.preventDefault();
    this.inputTarget.value = parseInt(this.inputTarget.value) + 1;
  }
}
