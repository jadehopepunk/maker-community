import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.inputTarget.setAttribute("tabindex", "-1");
    this.inputTarget.addEventListener("focus", this.preventFocus);
    this.updateClasses();
  }

  decrement(event) {
    event.preventDefault();
    this.setValue(Math.max(this.value() - 1, this.min()));
  }

  increment(event) {
    event.preventDefault();
    this.setValue(Math.min(this.value() + 1, this.max()));
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

  setValue(newValue) {
    this.inputTarget.value = newValue;
    this.updateClasses();
    this.inputTarget.dispatchEvent(new Event("change"));
  }

  min() {
    return parseInt(this.inputTarget.dataset.min);
  }

  max() {
    return parseInt(this.inputTarget.dataset.max);
  }

  // Private

  updateClasses() {
    if (this.value() == 0) {
      this.element.classList.add("zero");
    } else {
      this.element.classList.remove("zero");
    }
  }
}
