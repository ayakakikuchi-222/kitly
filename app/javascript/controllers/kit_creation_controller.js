import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  show() {
    this.overlayTarget.classList.remove("d-none")
    this.overlayTarget.classList.add("d-flex")
  }

  hide() {
    this.overlayTarget.classList.remove("d-flex")
    this.overlayTarget.classList.add("d-none")
  }
}
