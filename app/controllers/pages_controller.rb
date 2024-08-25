class PagesController < ApplicationController
  before_action :redirect_if_authenticated

  def home
  end

  private

  def redirect_if_authenticated
    if user_signed_in?
      redirect_to groups_path
    end
  end
end
