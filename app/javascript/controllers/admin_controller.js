import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "sidebar", "backdrop", "toggle" ]

  connect() {
    this.close = this.close.bind(this)
    this.toggle = this.toggle.bind(this)

    if (this.hasToggleTarget) {
      this.toggleTarget.addEventListener("click", this.toggle)
    }

    if (this.hasBackdropTarget) {
      this.backdropTarget.addEventListener("click", this.close)
    }
  }

  disconnect() {
    if (this.hasToggleTarget) {
      this.toggleTarget.removeEventListener("click", this.toggle)
    }

    if (this.hasBackdropTarget) {
      this.backdropTarget.removeEventListener("click", this.close)
    }
  }

  toggle() {
    this.sidebarTarget.classList.toggle("is-open")
    this.backdropTarget.classList.toggle("is-open")
  }

  close() {
    this.sidebarTarget.classList.remove("is-open")
    this.backdropTarget.classList.remove("is-open")
  }
}
