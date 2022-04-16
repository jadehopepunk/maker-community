import { Controller } from "@hotwired/stimulus";

function giveClassIf(element, class_name, condition) {
  if (condition) {
    element.classList.add(class_name);
  } else {
    element.classList.remove(class_name);
  }
}

export default class extends Controller {
  connect() {
    this.personInputs.forEach((input) => {
      input.addEventListener("change", this.bookingCountUpdated.bind(this));
    });
    this.updateClasses();
  }

  bookingCountUpdated(event) {
    this.updateClasses();
  }

  // PRIVATE

  updateClasses() {
    console.log("cost", this.totalCost);
    giveClassIf(this.element, "free", this.totalCost == 0);
  }

  get totalCost() {
    return this.bookingNumbers.reduce((total, booking) => {
      return total + booking.people * booking.price;
    }, 0);
  }

  get bookingNumbers() {
    const result = [];
    this.priceSections.forEach((section) => {
      const price = parseFloat(section.dataset.pricePerPerson);
      const people = parseInt(section.querySelector("input.small_integer").value);
      result.push({ price, people });
    });
    return result;
  }

  get priceSections() {
    return this.element.querySelectorAll(".for-one-price");
  }

  get personInputs() {
    return this.element.querySelectorAll(".for-prices input.small_integer");
  }
}
