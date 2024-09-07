class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :set_current_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :add_user_to_group, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def add_user_to_group
    return unless session[:invite_token].present? && current_user.present?

    group = Group.find_by(last_token: session[:invite_token])
    return unless group.present?

    group.add_user(current_user)
    session.delete(:invite_token)
    group.generate_token
    flash[:notice] = "Você foi adicionado ao grupo!"
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    groups_path
  end

  def after_sign_up_path_for(resource)
    groups_path
  end

  private

  def set_current_user
    @user = current_user
  end

  def user_not_authorized(exception)
    flash[:alert] = exception.message
    redirect_to(request.referer || root_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
