class SessionsController < ApplicationController
  skip_before_action :require_login
  
  def new
  end
  
  def create
    user = login(params[:username], params[:password])
    if user
      redirect_to root_url, notice: "Logged in."
    else
      redirect_to new_session_path, alert: "Username or password was invalid."
    end
  end
  
  def destroy
    logout
    redirect_to login_path, notice: "Logged out."
  end
end
