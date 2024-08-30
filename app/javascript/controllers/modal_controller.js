import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal"];

  connect() {
    console.log('Modal controller connected');
    console.log('Modal target:', this.modalTarget);
  }

  toggle() {
    console.log('Toggling modal');
    if (this.hasModalTarget) {
      this.modalTarget.classList.toggle("hidden");
    } else {
      console.error('Modal target not found');
    }
  }

  close() {
    console.log('Closing modal');
    if (this.hasModalTarget) {
      this.modalTarget.classList.add("hidden");
    } else {
      console.error('Modal target not found');
    }
  }
}
