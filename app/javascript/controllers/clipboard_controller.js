import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]

  copy(event) {
    const button = event.currentTarget
    const text = this.sourceTarget.innerText

    this.writeText(text).then(() => this.showCopied(button))
  }

  // Uses the modern clipboard when the browser allows it, otherwise the classic copy.
  // (Chrome can refuse the modern one, for example right after you click over from another window.)
  writeText(text) {
    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text).catch(() => this.classicCopy(text))
    }
    return Promise.resolve(this.classicCopy(text))
  }

  classicCopy(text) {
    const box = document.createElement("textarea")
    box.value = text
    box.setAttribute("readonly", "")
    box.style.position = "fixed"
    box.style.opacity = "0"
    document.body.appendChild(box)
    box.select()
    document.execCommand("copy")
    box.remove()
  }

  // Shows "Copied!" on the button for 1.5 seconds
  showCopied(button) {
    if (!button.dataset.label) button.dataset.label = button.innerHTML
    button.innerHTML = '<i class="fa-solid fa-check"></i> Copied!'
    button.classList.add("is-copied")

    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      button.innerHTML = button.dataset.label
      button.classList.remove("is-copied")
    }, 1500)
  }
}
