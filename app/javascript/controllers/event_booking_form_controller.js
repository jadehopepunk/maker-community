import { Controller } from "@hotwired/stimulus";

function giveClassIf(element, class_name, condition) {
  if (condition) {
    element.classList.add(class_name);
  } else {
    element.classList.remove(class_name);
  }
}

function formatMoney(amount) {
  var formatter = new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",

    // These options are needed to round to whole numbers if that's what you want.
    //minimumFractionDigits: 0, // (this suffices for whole numbers, but will print 2500.10 as $2,500.1)
    //maximumFractionDigits: 0, // (causes 2500.99 to be printed as $2,501)
  });

  return formatter.format(amount);
}

export default class extends Controller {
  static targets = ["submit", "cost"];

  connect() {
    this.personInputs.forEach((input) => {
      input.addEventListener("change", this.bookingCountUpdated.bind(this));
    });
    this.bookingCountUpdated();
  }

  bookingCountUpdated(event) {
    this.updateClasses();

    const cost = this.totalCost;

    if (this.totalCost > 0) {
      // initializeStripeForm(cost);
    }
  }

  // PRIVATE

  updateClasses() {
    const cost = this.totalCost;
    const free = cost == 0;

    this.submitTarget.value = free ? "Book now" : "Proceed to payment";
    this.costTarget.innerText = formatMoney(cost);
    giveClassIf(this.element, "free", free);
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
