import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}

  toggle(event) {
    event.preventDefault();
    console.log("toggle");
  }
}
