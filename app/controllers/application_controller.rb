class ApplicationController < ActionController::Base
  include Pundit
  before_action :set_current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_current_user
    @current_user = current_user
  end

  def user_not_authorized(exception)
    flash[:alert] = exception.message
    redirect_to(request.referer || root_path)
  end
end
