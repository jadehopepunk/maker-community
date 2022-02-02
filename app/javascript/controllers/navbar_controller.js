import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["title"];

  connect() {
    this.offsetTop = this.titleTarget.offsetTop;
    this.openHeight = this.element.offsetHeight;
  }

  onScroll(event) {
    const scrollY = window.scrollY;

    if (scrollY >= this.offsetTop) {
      this.element.classList.add("sticky");
    } else {
      this.element.classList.remove("sticky");
    }

    // console.log("bottom", this.isAtBottom());

    if (this.openHeight - scrollY <= 64 || this.isAtBottom()) {
      this.element.classList.add("closed");
    } else {
      this.element.classList.remove("closed");
    }
  }

  isAtBottom() {
    const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    return window.scrollY >= height - 1;
  }
}
