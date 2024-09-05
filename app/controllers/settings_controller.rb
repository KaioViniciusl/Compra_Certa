class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    if password_present?
      if current_user.update(user_params)
        bypass_sign_in(current_user) if current_user.saved_change_to_encrypted_password?
        redirect_to settings_path, notice: "Configurações da conta atualizadas com sucesso."
      else
        flash.now[:alert] = "Não foi possível atualizar as configurações. Verifique os erros abaixo."
        render :show
      end
    else
      if current_user.update_without_password(user_params.except(:password, :password_confirmation))
        redirect_to settings_path, notice: "Configurações da conta atualizadas com sucesso."
      else
        flash.now[:alert] = "Não foi possível atualizar as configurações. Verifique os erros abaixo."
        render :show
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :photo)
  end

  def password_present?
    params[:user].present? && (params[:user][:password].present? || params[:user][:password_confirmation].present?)
  end
end
