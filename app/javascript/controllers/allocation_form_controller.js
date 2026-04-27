import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template", "row", "destroyField", "total"]
  static values = { index: Number }

  connect() {
    this.updateTotal()
  }

  addAllocation() {
    const content = this.templateTarget.innerHTML.replaceAll("NEW_RECORD", this.indexValue)
    this.containerTarget.insertAdjacentHTML("beforeend", content)
    this.indexValue += 1
    this.updateTotal()
  }

  removeAllocation(event) {
    const row = event.currentTarget.closest("[data-allocation-form-target='row']")
    const destroyField = row.querySelector("[data-allocation-form-target='destroyField']")

    if (destroyField) {
      destroyField.value = "1"
    }

    row.classList.add("is-hidden")
    this.updateTotal()
  }

  updateTotal() {
    const total = this.rowTargets.reduce((sum, row) => {
      if (row.classList.contains("is-hidden")) {
        return sum
      }

      const percentageField = row.querySelector("input[name*='[percentage]']")
      return sum + Number.parseInt(percentageField?.value || "0", 10)
    }, 0)

    this.totalTarget.textContent = `${total}%`
    this.totalTarget.classList.toggle("has-text-danger", total !== 100)
    this.totalTarget.classList.toggle("has-text-success", total === 100)
  }
}
