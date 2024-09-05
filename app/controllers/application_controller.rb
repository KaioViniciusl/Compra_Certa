class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :set_current_user
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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
