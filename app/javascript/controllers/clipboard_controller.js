import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = [];

  copyToClipboard(event) {
    event.preventDefault();

    const groupId = this.element.dataset.clipboardGroupId;
    const token = this.element.dataset.clipboardToken;

    if (!groupId || !token) {
      console.error('Group ID ou token não presentes.');
      return;
    }

    const baseUrl = window.location.origin;
    const inviteLink = `${baseUrl}/groups/${groupId}/accept_invite/${token}`;

    navigator.clipboard.writeText(inviteLink).then(() => {
      this.element.textContent = "Link copiado!";

      setTimeout(() => {
        this.element.textContent = "Compartilhar";
      }, 2000);
    }).catch(err => {
      console.error('Erro ao copiar o link: ', err);
    });
  }
}
