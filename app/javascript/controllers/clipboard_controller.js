import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]

  copy(event) {
    const text = this.sourceTarget.innerText
    navigator.clipboard.writeText(text).then(() => {
      const btn = event.currentTarget
      const original = btn.innerHTML
      btn.innerHTML = '<i class="fa-solid fa-check"></i>'
      setTimeout(() => { btn.innerHTML = original }, 1500)
    })
  }
}
