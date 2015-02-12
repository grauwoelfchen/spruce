require "test_helper"

class SessionsControllerTest < ActionController::TestCase
  fixtures(:users)

  setup(:initialize_user)
  teardown(:logout)

  # actions

  def test_new_session_with_logged_in_user
    login_user(@user)
    get(:new)

    assert_response(:redirect)
    assert_redirected_to(root_url)
  end

  def test_new_session
    get(:new)

    assert_template(:new)
    assert_response(:success)
  end

  def test_create_session_with_logged_in_user
    login_user(@user)
    attributes = {
      :username    => @user.username,
      :password    => "secret",
      :remember_me => "1"
    }
    post(:create, attributes)

    assert_equal(session[:user_id], @user.id)
    assert_nil(flash.notice)
    assert_nil(flash.alert)
    assert_response(:redirect)
    assert_redirected_to(root_url)
  end

  def test_create_session_with_validation_errors
    post(:create, :username => "", :password => "")
    assert_nil(session[:user_id])
    assert_nil(flash.notice)
    assert_equal(flash.alert, "Username or password was invalid")
    assert_template(:new)
    assert_response(:success)
  end

  def test_create_session
    attributes = {
      :username    => @user.username,
      :password    => "secret",
      :remember_me => "1"
    }
    post(:create, attributes)

    assert_equal(session[:user_id], @user.id)
    assert_equal(flash.notice, "Logged in ;)")
    assert_nil(flash.alert)
    assert_response(:redirect)
    assert_redirected_to(root_url)
  end

  # methods

  def test_destroy_with_anonymous_user
    get(:destroy)

    assert_nil(session[:user_id])
    assert_nil(flash.notice)
    assert_nil(flash.alert)
    assert_response(:redirect)
    assert_redirected_to(login_url)
  end

  def test_destroy_with_logged_in_user
    login_user(@user)
    get(:destroy)

    assert_nil(session[:user_id])
    assert_equal(flash.notice, "Logged out :p")
    assert_nil(flash.alert)
    assert_response(:redirect)
    assert_redirected_to(root_url)
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
