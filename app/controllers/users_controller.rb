class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :activate]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_url, :notice => "Signed up! Please check email :)"
    else
      render :new
    end
  end

  def activate
    @user = User.load_from_activation_token(params[:token])
    if @user
      @user.transaction do
        @user.activate!
        @user.create_home!
      end
      redirect_to nodes_url, :notice => "Your were successfully activated :-D"
    else
      not_authenticated
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
