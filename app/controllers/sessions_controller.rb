class SessionsController < ApplicationController
  before_filter :admit_only_new_user, :only => [:new, :create]

  def new
  end

  def create
    user = login(params[:username], params[:password], params[:remember_me])
    if user
      redirect_back_or_to root_url, :notice => "Logged in ;)"
    else
      flash.now.alert = "Username or password was invalid"
      render :new
    end
  end

  def destroy
    unless current_user
      redirect_to login_url
    else
      logout
      redirect_to root_url, :notice => "Logged out :p"
    end
  end

  private

    def admit_only_new_user
      redirect_to(root_url) if current_user
    end
end
