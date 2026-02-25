import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "openIcon", "closeIcon", "button"]

  connect() {
    this.syncAria()
  }

  toggle() {
    this.panelTarget.classList.toggle("hidden")
    this.openIconTarget.classList.toggle("hidden")
    this.closeIconTarget.classList.toggle("hidden")
    this.syncAria()
  }

  syncAria() {
    if (!this.hasButtonTarget) return

    this.buttonTarget.setAttribute("aria-expanded", this.panelTarget.classList.contains("hidden") ? "false" : "true")
  }
}
