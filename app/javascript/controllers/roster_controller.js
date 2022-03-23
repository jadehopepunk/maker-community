import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["edits"];

  connect() {
    this.editing = null;

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
    if (this.editing) return;

    this.editing = userId;
    this.element.classList.add("editing");
    this.element.querySelectorAll(`[data-user="${userId}"]`).forEach((element) => {
      element.classList.add("editing");
    });
    console.log("start editing", userId);
  }

  // private
}
