class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  before_action :require_login

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    
  private

  def not_authenticated
    redirect_to login_path, alert: "Log in to view this page."
  end

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to request.headers["Referer"] || root_path
  end
end
