import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "toggleButton"]

  toggle() {
    const hidden = this.panelTarget.classList.toggle("is-hidden")
    this.toggleButtonTarget.textContent = hidden ? "Edit" : "Cancel"
  }
}
