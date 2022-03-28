import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";

const AVAILABILITIES = ["unknown", "busy", "available"];

export default class extends Controller {
  static targets = ["edits", "rosterBody"];

  connect() {
    this.editing = null;
    this.editingManager = false;

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

    if (target.classList.contains("user-slot")) {
      event.preventDefault();

      if (this.editing) {
        if (target.classList.contains("editing")) {
          this.onEditClick(target);
        }
      } else if (this.editingManager) {
        this.onEditManagerClick(target);
      }
    }
  }

  onEditClick(cell) {
    const availability = this.nextAvailability(cell.dataset["availability"]);
    cell.dataset["availability"] = availability;
    cell.innerText = availability;
  }

  onEditManagerClick(cell) {
    const user = cell.dataset["user"];
    const sessionId = cell.parentElement.dataset["sessionId"];
    this.toggleManager(user, sessionId, cell);
  }

  cancelEdit(event) {
    this.editing = null;
    this.editingManager = false;
    this.clearEditingClass();
    this.clearEditingManagerClass();
  }

  cancelEditManager(event) {
    location.reload();
  }

  saveEdit(event) {
    event.preventDefault();

    const values = this.currentEditValues();

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

  saveEditManager(event) {
    event.preventDefault();

    const values = this.currentManagers();
    var fd = new FormData();
    fd.append("session_managers", JSON.stringify(values));

    Rails.ajax({
      type: "POST",
      url: "/admin/program/open_times/update_managers",
      data: fd,
    });

    this.cancelEdit();
  }

  startEditing(userId) {
    if (this.editing || this.editingManager) return;

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

  editManager(event) {
    event.preventDefault();
    if (this.editing || this.editingManager) return;

    this.editingManager = true;
    this.clearEditingClass();
    this.setEditingManagerClass();
  }

  toggleManager(user, sessionId, userCell) {
    const isManager = userCell.dataset["role"] == "manager";

    if (isManager) {
      this.makeNotManager(user, sessionId, userCell);
    } else {
      this.makeManager(user, sessionId, userCell);
    }
  }

  makeManager(user, sessionId, userCell) {
    const managerCell = this.getManagerCell(sessionId);

    userCell.dataset["role"] = "manager";
    this.addManagerToCell(managerCell, user);
    this.updateManagerCellText(managerCell);
  }

  makeNotManager(user, sessionId, userCell) {
    const managerCell = this.getManagerCell(sessionId);

    userCell.dataset["role"] = null;
    this.removeManagerFromCell(managerCell, user);
    this.updateManagerCellText(managerCell);
  }

  // private

  currentManagers() {
    var result = {};

    this.rosterBodyTarget.querySelectorAll("tr").forEach((row) => {
      const sessionId = row.dataset["sessionId"];
      const users = this.managerCellIds(row.querySelector("td.manager"));
      result[sessionId] = users;
    });

    return result;
  }

  sessionIds() {
    return this.rosterBodyTarget.querySelectorAll("tr").map((row) => row.dataset["sessionId"]);
  }

  addManagerToCell(cell, user) {
    const existingManagers = this.managerCellIds(cell);
    const newManagers = existingManagers.includes(user) ? existingManagers : existingManagers.concat(user);
    cell.dataset["managers"] = newManagers.join(",");
  }

  removeManagerFromCell(cell, user) {
    const existingManagers = this.managerCellIds(cell);
    const newManagers = existingManagers.filter((item) => item !== user);
    cell.dataset["managers"] = newManagers.join(",");
  }

  managerCellIds(cell) {
    return (cell.dataset["managers"] || "").split(",").filter((e) => e);
  }

  updateManagerCellText(cell) {
    const managerIds = this.managerCellIds(cell);
    const managerNames = managerIds.map((id) => this.getUserName(id));
    cell.innerText = managerNames.join(", ");
  }

  getManagerCell(sessionId) {
    return this.getSessionRow(sessionId).querySelector(".manager");
  }

  getSessionRow(sessionId) {
    return this.rosterBodyTarget.querySelector(`[data-session-id="${sessionId}"]`);
  }

  nextAvailability(input) {
    return AVAILABILITIES[(AVAILABILITIES.indexOf(input) + 1) % AVAILABILITIES.length];
  }

  clearEditingClass() {
    this.element.classList.remove("editing");
    this.element.classList.remove("editing-manager");
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

  setEditingManagerClass() {
    this.element.classList.add("editing-manager");
  }

  clearEditingManagerClass() {
    this.element.classList.remove("editing-manager");
  }

  getUserName(userId) {
    return this.element.querySelector(`.user-header[data-user="${userId}"]`).innerText;
  }
}
