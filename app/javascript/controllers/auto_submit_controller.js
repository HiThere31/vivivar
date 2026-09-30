import { Controller } from "@hotwired/stimulus"

// Envía el formulario en cuanto cambia un toggle
export default class extends Controller {
  submit() {
    this.element.requestSubmit()
  }
}
