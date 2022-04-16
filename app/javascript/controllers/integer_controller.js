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
    this.inputTarget.value = Math.max(this.value() - 1, this.min());
  }

  increment(event) {
    event.preventDefault();
    this.inputTarget.value = Math.min(this.value() + 1, this.max());
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

  value() {
    return parseInt(this.inputTarget.value);
  }

  min() {
    return parseInt(this.inputTarget.dataset.min);
  }

  max() {
    return parseInt(this.inputTarget.dataset.max);
  }
}
