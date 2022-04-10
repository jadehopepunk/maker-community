import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];

  connect() {}

  click(event) {
    event.preventDefault();

    console.log("click", event.target.hash);
    const href = event.target.hash;
    document.querySelector(href).scrollIntoView({ behavior: "smooth" });
  }
}
