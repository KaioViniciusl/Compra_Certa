import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="photo-upload"
export default class extends Controller {
  static targets = ["input", "preview", "editLabel"]

  previewImage(event) {
    const file = this.inputTarget.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = () => {
        this.previewTarget.src = reader.result
      }
      reader.readAsDataURL(file)
    }
  }

  // Optional: Trigger file input click when the editLabel is clicked
  triggerFileInput() {
    this.inputTarget.click()
  }
}
