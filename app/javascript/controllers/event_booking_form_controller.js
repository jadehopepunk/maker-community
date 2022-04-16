import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    document.querySelectorAll(".for-prices input").forEach((input) => {
      console.log("binding to input", input);
      input.addEventListener("change", this.bookingCountUpdated.bind(this));
    });
  }

  bookingCountUpdated(event) {
    console.log("booking count updated");
  }
}
