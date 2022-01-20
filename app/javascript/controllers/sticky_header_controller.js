import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.startingHeight = this.element.getBoundingClientRect().height;
    this.isOpen = true;
    this.isLocked = false;
    this.oldScrollY = 0;
    this.element.classList.add("open");
    this.setMaxHeight(this.startingHeight);
    this.scrollTop = 60;
  }

  onScroll(event) {
    const scrollY = window.scrollY;

    console.log("event");

    if (true) {
      if (this.isOpen) {
        console.log(window.scrollY);
        if (window.scrollY > this.scrollTop) {
          this.close();
        }
      } else {
        console.log("scrollY", scrollY);
        if (window.scrollY <= 1) {
          this.open();
        }
      }
    }

    this.oldScrollY = scrollY;
  }

  close() {
    this.lock();
    console.log("closing");
    this.isOpen = false;
    this.setMaxHeight(50);
    this.element.classList.remove("open");
    this.element.classList.add("closed");
  }

  open() {
    this.lock();
    console.log("opening");
    this.isOpen = true;
    this.setMaxHeight(this.startingHeight);
    this.element.classList.remove("closed");
    this.element.classList.add("open");
  }

  lock() {
    this.isLocked = true;
    setTimeout(() => this.unlock(), 1000);
  }

  unlock() {
    this.isLocked = false;
  }

  setMaxHeight(value) {
    this.element.setAttribute("style", `max-height: ${value}px`);
  }

  isScrollingDown(scrollY) {
    return scrollY > this.oldScrollY;
  }
}
