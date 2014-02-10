require "test_helper"

class SessionsControllerTest < ActionController::TestCase
  fixtures :users

  setup    :login, :initialize_user
  teardown :logout

  def test_new_session
    get :new
    assert_response :success
  end

  def test_create_session_with_validation_errors
    post :create, :username => "", :password => ""
    assert_response :success
    assert_template :new
  end

  def test_create_session
    @user.activate!
    post :create, :username => @user.username, :password => "secret", :remember_me => "1"
    assert_response :redirect
    assert_redirected_to root_url
  end

  private

  def login
    user = users(:tim)
    login_user(user)
  end

  def initialize_user
    @user = users(:tim)
  end

  def logout
    logout_user
  end
end
