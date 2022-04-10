import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["nav"];

  connect() {
    this.offsetTop = this.navTarget.offsetTop;
    this.openHeight = this.element.offsetHeight;
    this.heightAbove = 64;
    this.closedVisibleHeight = this.navTarget.offsetHeight;
    this.closedTotalHeight = this.closedVisibleHeight + this.heightAbove;
    this.startsClosed = this.element.classList.contains("closed");
  }

  onScroll(event) {
    const scrollY = window.scrollY;
    if (this.openHeight - this.heightAbove - scrollY <= 0 || this.isAtBottom()) {
      this.close();
    } else {
      this.open();
    }
  }

  isAtBottom() {
    const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    return window.scrollY >= height - 1;
  }

  close() {
    this.element.classList.add("closed");
    this.element.style.top = `${this.closedTotalHeight - this.openHeight}px`;
  }

  open() {
    this.element.classList.remove("closed");
    this.element.style.top = null;
  }
}
