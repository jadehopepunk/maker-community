import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["edits", "rosterBody"];

  connect() {
    this.editing = null;

    this.editsTarget.querySelectorAll("[data-action=edit]").forEach((element) => {
      element.addEventListener("click", (element) => this.onEdit(element));
    });

    this.rosterBodyTarget.addEventListener("click", (element) => this.onBodyClick(element));
  }

  onEdit(event) {
    const userId = event.target.dataset.user;
    this.startEditing(userId);
    event.preventDefault();

    return false;
  }

  onBodyClick(event) {
    const target = event.target;

    if (target.classList.contains("user-slot") && target.classList.contains("editing")) {
      this.onEditClick(target);
      event.preventDefault();
    }
  }

  onEditClick(cell) {
    console.log("edit click", cell);
  }

  startEditing(userId) {
    if (this.editing) return;

    this.editing = userId;
    this.element.classList.add("editing");
    this.element.querySelectorAll(`[data-user="${userId}"]`).forEach((element) => {
      element.classList.add("editing");
    });
    console.log(this.rosterBodyTarget);
    console.log("start editing", userId);
  }

  // private
}
