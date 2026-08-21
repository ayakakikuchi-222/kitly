import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]

  toggle() {
    this.contentTarget.classList.toggle("d-none")

    if (this.contentTarget.classList.contains("d-none")) {
      this.iconTarget.classList.remove("fa-minus")
      this.iconTarget.classList.add("fa-plus")
    } else {
      this.iconTarget.classList.remove("fa-plus")
      this.iconTarget.classList.add("fa-minus")
    }
  }
}
