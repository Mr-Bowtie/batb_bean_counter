import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ['menu']
  connect() {
  }

  toggleMenu() {
    const target = this.menuTarget
    if (target.classList.contains("is-active")) {
      target.classList.remove("is-active")
      return
    }

    target.classList.add("is-active")
  }
}
