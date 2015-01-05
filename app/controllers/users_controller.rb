class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :activate]
  before_filter :force_logout, :only => [:create, :activate]

  def new
    redirect_to root_url if current_user
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, :notice => "Signed up! Please check email :)"
    else
      render :new
    end
  end

  def activate
    authority = ActivationAuthority.new(params[:token])
    if authority.activate!
      redirect_to login_url, :notice => "Your were successfully activated, Please login :-D"
    else
      not_authenticated
    end
  end

  private

  def force_logout
    if current_user
      logout
      redirect_to root_url
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
