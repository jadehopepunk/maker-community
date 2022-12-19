import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("admin menu connect");
  }

  toggle(event) {
    console.log("toggle");
    event.preventDefault();
    if (this.isOpen()) {
      this.close();
    } else {
      this.open();
    }
  }

  isOpen() {
    return this.element.classList.contains("open");
  }

  open() {
    this.element.classList.add("open");
  }

  close() {
    this.element.classList.remove("open");
  }
}
