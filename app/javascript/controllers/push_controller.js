import { Controller } from "@hotwired/stimulus"

// Activa las notificaciones push en este dispositivo.
// mode "settings": muestra estado + botón (Nosotros)
// mode "banner":   solo aparece si aún no se han pedido permisos (Hoy)
export default class extends Controller {
  static targets = ["status", "button"]
  static values = { vapidKey: String, mode: { type: String, default: "settings" } }

  connect() {
    this.refresh()
  }

  async enable() {
    // En iOS requestPermission tiene que salir directo del toque
    if (this.hasButtonTarget) this.buttonTarget.disabled = true
    try {
      await Notification.requestPermission()
    } finally {
      if (this.hasButtonTarget) this.buttonTarget.disabled = false
    }
    await this.refresh()
  }

  async refresh() {
    if (!this.supported || !this.vapidKeyValue) {
      const msg = this.isIOS && !this.standalone
        ? "Ábrela desde el ícono de inicio para activarlas."
        : "Este navegador no soporta notificaciones."
      return this.render(msg, false)
    }

    if (Notification.permission === "denied") {
      return this.render("Están bloqueadas. Actívalas en Ajustes → Notificaciones → Nuestro diario.", false)
    }

    if (Notification.permission === "granted") {
      try {
        await this.subscribe()
        return this.render("Activas en este dispositivo ✓", false)
      } catch (error) {
        console.error(error)
        return this.render("No se pudieron activar. Intenta otra vez.", true)
      }
    }

    this.render("", true)
  }

  async subscribe() {
    const registration = await navigator.serviceWorker.register("/service-worker", { scope: "/" })
    await navigator.serviceWorker.ready

    const subscription = await registration.pushManager.getSubscription() ||
      await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: this.applicationServerKey
      })

    const response = await fetch("/push_subscriptions", {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content
      },
      body: JSON.stringify({ subscription: subscription.toJSON() })
    })
    if (!response.ok) throw new Error(`push_subscriptions ${response.status}`)
  }

  render(text, canEnable) {
    if (this.modeValue === "banner") {
      this.element.hidden = !(canEnable && !text)
      return
    }
    if (this.hasStatusTarget) this.statusTarget.textContent = text || "Te avisamos cuando suba su foto."
    if (this.hasButtonTarget) this.buttonTarget.hidden = !canEnable
  }

  get supported() {
    return "serviceWorker" in navigator && "PushManager" in window && "Notification" in window
  }

  get isIOS() {
    return /iPad|iPhone|iPod/.test(navigator.userAgent) ||
      (navigator.platform === "MacIntel" && navigator.maxTouchPoints > 1)
  }

  get standalone() {
    return window.navigator.standalone === true || window.matchMedia("(display-mode: standalone)").matches
  }

  get applicationServerKey() {
    const base64 = (this.vapidKeyValue + "=".repeat((4 - this.vapidKeyValue.length % 4) % 4))
      .replace(/-/g, "+").replace(/_/g, "/")
    return Uint8Array.from(atob(base64), (c) => c.charCodeAt(0))
  }
}
