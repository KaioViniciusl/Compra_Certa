class Users::RegistrationsController < Devise::RegistrationsController
  after_action :add_user_to_group, only: [:create]

  def after_sign_up_path_for(resource)
    groups_path
  end

  private

  def add_user_to_group
    token = session.delete(:last_token)

    if token.present?
      group = Group.find_by(last_token: token)
      if group.present?
        group.user_groups.create(user: current_user, user_mail: current_user.email, invite_accepted: true) unless current_user.groups.include?(group)
        flash[:notice] = "Você foi adicionado ao grupo!"
      else
        flash[:alert] = "Token de convite inválido."
      end
    end
  end
end
