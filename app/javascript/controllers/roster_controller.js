import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";

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
    const availability = this.nextAvailability(cell.dataset["availability"]);
    cell.dataset["availability"] = availability;
    cell.innerText = availability;
  }

  cancelEdit(event) {
    this.editing = null;
    this.clearEditingClass();
  }

  saveEdit(event) {
    const values = this.currentEditValues();
    console.log("values", values);

    var fd = new FormData();
    fd.append("entries", JSON.stringify(values));
    fd.append("user_id", this.editing);

    Rails.ajax({
      type: "POST",
      url: "/admin/program/open_times/bulk_update",
      data: fd,
    });

    this.cancelEdit();
  }

  startEditing(userId) {
    if (this.editing) return;

    this.editing = userId;
    this.clearEditingClass();
    this.setEditingClass(userId);
  }

  currentEditValues() {
    if (!this.editing) return [];
    return this.userValues(this.editing);
  }

  userValues(userId) {
    var result = {};

    this.rosterBodyTarget.querySelectorAll(`[data-user="${userId}"]`).forEach((element) => {
      const availability = element.dataset["availability"];
      const sessionId = element.parentElement.dataset["sessionId"];
      result[sessionId] = availability;
    });

    return result;
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
