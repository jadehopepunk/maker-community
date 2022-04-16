import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    console.log("connected", this.element);
    this.inputTarget.setAttribute("tabindex", "-1");
    this.inputTarget.addEventListener("focus", this.preventFocus);
  }

  decrement(event) {
    event.preventDefault();
    this.inputTarget.value = parseInt(this.inputTarget.value) - 1;
  }

  increment(event) {
    event.preventDefault();
    this.inputTarget.value = parseInt(this.inputTarget.value) + 1;
  }

  preventFocus(event) {
    event.preventDefault();
    if (event.relatedTarget) {
      // Revert focus back to previous blurring element
      event.relatedTarget.focus();
    } else {
      // No previous focus target, blur instead
      event.currentTarget.blur();
    }
  }
}
