import { Controller } from "@hotwired/stimulus";

const heightBuffer = 20;

export default class extends Controller {
  static targets = [];

  connect() {
    this.heights = this.findTargetHeights();
  }

  click(event) {
    event.preventDefault();

    const href = event.target.hash;
    document.querySelector(href).scrollIntoView({ behavior: "smooth" });
  }

  onScroll(event) {
    const targetId = this.findLinkTarget(window.scrollY);
    this.setActiveLink(targetId);
  }

  // Private

  findTargetHeights() {
    const targets = document.querySelectorAll(".scroll-target a");
    const heights = [];
    targets.forEach((target) => {
      const id = target.id;
      const height = target.getBoundingClientRect().top;
      heights.push({ id, height });
    });
    return heights;
  }

  setActiveLink(targetId) {
    const links = this.element.querySelectorAll("a");
    links.forEach((a) => {
      if (targetId && a.hash === `#${targetId}`) {
        a.classList.add("active");
        a.scrollIntoView({ behavior: "smooth" });
      } else {
        a.classList.remove("active");
      }
    });
  }

  findLinkTarget(scrollY) {
    for (let { height, id } of this.heights.slice().reverse()) {
      if (scrollY >= height - heightBuffer) {
        return id;
      }
    }
    return null;
  }
}
