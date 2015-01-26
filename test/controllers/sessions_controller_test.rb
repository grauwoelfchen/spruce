require "test_helper"

class SessionsControllerTest < ActionController::TestCase
  fixtures :users

  setup :initialize_user
  teardown :logout

  def test_new_session_for_logged_in_user
    login_user(@user)
    get :new
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_new_session
    get :new
    assert_response :success
  end

  def test_create_session_for_logged_in_user
    login_user(@user)
    attributes = {
      :username    => @user.username,
      :password    => "secret",
      :remember_me => "1"
    }
    post :create, attributes
    assert_not_equal flash.notice, "Logged in ;)"
    assert_not_equal flash.alert,  "Username or password was invalid"
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_create_session_with_validation_errors
    post :create, :username => "", :password => ""
    assert_equal flash.alert, "Username or password was invalid"
    assert_response :success
    assert_template :new
  end

  def test_create_session
    attributes = {
      :username    => @user.username,
      :password    => "secret",
      :remember_me => "1"
    }
    post :create, attributes
    assert_equal session[:user_id], @user.id
    assert_equal flash.notice, "Logged in ;)"
    assert_response :redirect
    assert_redirected_to root_url
  end

  private

    def initialize_user
      @user = users(:tim)
      @user.activate!
    end

    def logout
      logout_user
    end
end
