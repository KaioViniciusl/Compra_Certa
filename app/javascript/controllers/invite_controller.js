import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["email", "addedMembers", "hiddenInviteEmails"]

  connect() {
    this.invites = []
  }

  addMember() {
    const email = this.emailTarget.value.trim()
    if (email && !this.invites.includes(email)) {
      this.invites.push(email)
      this.updateAddedMembers()
      this.hiddenInviteEmailsTarget.value = this.invites.join(",")
      this.emailTarget.value = ""
    }
  }

  updateAddedMembers() {
    this.addedMembersTarget.innerHTML = this.invites.map(email =>
      `<div class="added-member">${email} <button type="button" data-action="click->invite#removeMember" data-email="${email}">&times;</button></div>`
    ).join("")
  }

  removeMember(event) {
    const email = event.target.getAttribute("data-email")
    this.invites = this.invites.filter(e => e !== email)
    this.updateAddedMembers()
    this.hiddenInviteEmailsTarget.value = this.invites.join(",")
  }
}
