import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.style.transition = "transform 0.5s ease-in, opacity 0.5s ease-in"
      this.element.style.transform = "translateX(120%)"
      this.element.style.opacity = "0"
      setTimeout(() => this.element.remove(), 500)
    }, 2000)
  }
}
