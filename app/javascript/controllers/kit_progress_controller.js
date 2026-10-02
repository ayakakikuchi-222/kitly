import { Controller } from "@hotwired/stimulus"

// Kit page loading screen: asks the server every few seconds how many components are ready.
// When the kit is finished, it reloads the page, so all the components appear together.
export default class extends Controller {
  static targets = ["step", "count"]
  static values = { url: String, interval: { type: Number, default: 3000 } }

  connect() {
    this.active = true
    this.check()
  }

  disconnect() {
    this.active = false
    clearTimeout(this.timer)
  }

  async check() {
    try {
      const response = await fetch(this.urlValue, { headers: { Accept: "application/json" }, cache: "no-store" })
      if (response.ok) {
        const status = await response.json()
        if (!this.active) return

        this.showProgress(Math.min(status.ready, status.total))
        if (!status.generating) return this.reveal()
      }
    } catch (error) {
      // no answer this time (e.g. the server is busy or restarting), try again below
    }
    if (this.active) this.timer = setTimeout(() => this.check(), this.intervalValue)
  }

  showProgress(ready) {
    this.countTarget.textContent = ready
    this.stepTargets.forEach((step, index) => {
      step.classList.toggle("is-done", index < ready)
      step.classList.toggle("is-active", index === ready)
    })
  }

  reveal() {
    this.active = false
    if (window.Turbo) {
      window.Turbo.visit(window.location.href, { action: "replace" })
    } else {
      window.location.reload()
    }
  }
}
