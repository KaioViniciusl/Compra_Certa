class UserMailer < ApplicationMailer
  default from: "contacertawebdev@gmail.com"

  def invite_email(group_id, email, user = nil)
    @group = Group.find(group_id)
    @user = user
    email = email

    if @user.present?
      @url = group_url(@group)
    else
      @url = new_user_registration_url
    end

    mail(to: email, subject: "Você foi convidado para um grupo!")
  end

  private

  def group_url(group)
    Rails.application.routes.url_helpers.group_url(group, default_url_options)
  end

  def default_url_options
    if Rails.env == "production"
      { host: "contacerta.site" }
    else
      { host: "localhost", port: 3000 }
    end
  end
end
