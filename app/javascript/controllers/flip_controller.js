import { Controller } from "@hotwired/stimulus"

// Voltea la polaroid de la otra persona la primera vez que se ve revelada
export default class extends Controller {
  static values = { key: String }

  connect() {
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches

    if (this.seen || reduce) {
      this.element.classList.add("no-anim", "is-flipped")
      return
    }

    this.timer = setTimeout(() => {
      this.element.classList.add("is-flipped")
      this.markSeen()
    }, 700)
  }

  disconnect() {
    clearTimeout(this.timer)
  }

  get seen() {
    try { return localStorage.getItem(this.keyValue) === "1" } catch { return false }
  }

  markSeen() {
    try { localStorage.setItem(this.keyValue, "1") } catch {}
  }
}
