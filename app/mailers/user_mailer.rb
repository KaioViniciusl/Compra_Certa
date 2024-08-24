class UserMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def invite_email(group_id, email, user = nil)
    @group = Group.find(group_id)
    @user = user
    email = email

    if @user.present?
      @url = accept_invite_group_url(@group.id)
    else
      @url = new_user_registration_url
    end

    mail(to: email, subject: "Você foi convidado para um grupo!")
  end

  private

  def default_url_options
    { host: "localhost", port: 3000 } # Atualize com o host e a porta corretos
  end
end
