import { Controller } from "@hotwired/stimulus"

// Componer: vista previa de la foto, "Repetir" y contador del texto
export default class extends Controller {
  static targets = ["input", "frame", "preview", "placeholder", "retake", "submit", "caption", "counter"]

  connect() {
    this.count()
  }

  disconnect() {
    if (this.url) URL.revokeObjectURL(this.url)
  }

  preview() {
    const file = this.inputTarget.files[0]
    if (!file) return

    if (this.url) URL.revokeObjectURL(this.url)
    this.url = URL.createObjectURL(file)

    this.previewTarget.src = this.url
    this.previewTarget.hidden = false
    this.placeholderTarget.hidden = true
    this.frameTarget.classList.add("has-photo")
    this.retakeTarget.hidden = false
    this.submitTarget.disabled = false
  }

  retake() {
    this.inputTarget.click()
  }

  count() {
    if (this.hasCounterTarget && this.hasCaptionTarget) {
      this.counterTarget.textContent = this.captionTarget.value.length
    }
  }
}
