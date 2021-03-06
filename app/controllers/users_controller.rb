class UsersController < ApplicationController

  skip_before_action :require_login
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.add_role(:editor, Task) if params[:editor] == "true"
      redirect_to login_path, notice: "Signed up."
    else
      render :new
    end
  end
  
  private
    def user_params
      params.require(:user).permit!
    end
end
