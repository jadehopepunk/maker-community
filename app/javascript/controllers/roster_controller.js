import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["edits"];

  connect() {
    this.editsTarget.querySelectorAll("[data-action=edit]").forEach((element) => {
      element.addEventListener("click", (element) => this.onEdit(element));
    });
  }

  onEdit(event) {
    const userId = event.srcElement.dataset.user;
    this.startEditing(userId);
    event.preventDefault();
    return false;
  }

  startEditing(userId) {
    console.log("start editing", userId);
  }

  // private
}
