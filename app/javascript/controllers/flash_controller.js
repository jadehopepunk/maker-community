import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    setTimeout(this.fadeAllFlash.bind(this), 3000);
  }

  fadeAllFlash() {
    this.element.querySelectorAll(".flash").forEach((flash) => {
      flash.classList.add("fade-out");
    });
  }
}
