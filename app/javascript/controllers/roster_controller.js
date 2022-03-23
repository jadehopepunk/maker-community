import { Controller } from "@hotwired/stimulus";

const AVAILABILITIES = ["unknown", "busy", "available"];

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
    cell.dataset["availability"] = this.nextAvailability(cell.dataset["availability"]);
  }

  cancelEdit(event) {
    this.editing = null;
    this.clearEditingClass();
  }

  startEditing(userId) {
    if (this.editing) return;

    this.editing = userId;
    this.clearEditingClass();
    this.setEditingClass(userId);
  }

  // private

  nextAvailability(input) {
    return AVAILABILITIES[(AVAILABILITIES.indexOf(input) + 1) % AVAILABILITIES.length];
  }

  clearEditingClass() {
    this.element.classList.remove("editing");
    this.element.querySelectorAll(".editing").forEach((element) => {
      element.classList.add("editing");
    });
  }

  setEditingClass(userId) {
    this.element.classList.add("editing");
    this.element.querySelectorAll(`[data-user="${userId}"]`).forEach((element) => {
      element.classList.add("editing");
    });
  }
}
