class PasswordResetsController < ApplicationController
  skip_before_filter :require_login
  before_filter :load_user_from_token, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(:email => user_params[:email])
    if @user.valid_attribute?(:email, [:blank, :invalid])
      @user = User.find_by_email(user_params[:email])
      @user.deliver_reset_password_instructions! if @user
      redirect_to root_url,
        :notice => "Instructions have been sent to your email :)"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user.password_confirmation = user_params[:password_confirmation]
    if @user.change_password!(user_params[:password])
      redirect_to root_url,
        :notice => "Password was successfully updated !"
    else
      render :edit
    end
  end

  private

    def load_user_from_token
      logout
      @user  = User.load_from_reset_password_token(params[:token])
      @token = params[:token]
      return not_authenticated unless @user
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
