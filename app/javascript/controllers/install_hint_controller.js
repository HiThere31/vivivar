import { Controller } from "@hotwired/stimulus"

// Oculta los pasos de "Agregar a inicio" cuando ya se abrió como app instalada
export default class extends Controller {
  connect() {
    const standalone = window.navigator.standalone === true ||
      window.matchMedia("(display-mode: standalone)").matches

    this.element.hidden = standalone
  }
}
