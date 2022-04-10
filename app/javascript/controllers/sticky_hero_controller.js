import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["nav", "hero", "contents"];

  connect() {
    this.offsetTop = this.navTarget.offsetTop;
    this.openHeight = this.heroTarget.offsetHeight;
    this.heightAbove = 64;
    this.closedVisibleHeight = this.navTarget.offsetHeight;
    this.closedTotalHeight = this.closedVisibleHeight + this.heightAbove;
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
    this.heroTarget.classList.add("closed");
    this.heroTarget.style.top = `${this.closedTotalHeight - this.openHeight}px`;
    this.contentsTarget.style.paddingTop = `${this.openHeight}px`;
  }

  open() {
    this.heroTarget.classList.remove("closed");
    this.heroTarget.style.top = null;
    this.contentsTarget.style.paddingTop = null;
  }
}
