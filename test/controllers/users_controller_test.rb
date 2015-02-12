require "test_helper"

class UsersControllerTest < ActionController::TestCase
  fixtures(:users)

  # actions

  def test_get_new_with_logged_in_user
    user = signed_up_user
    user.activate!
    login_user(user)
    get(:new)
    refute(assigns(:user))
    assert_response(:redirect)
    assert_redirected_to(root_url)
    logout_user
  end

  def test_get_new
    get(:new)
    assert_instance_of(User, assigns(:user))
    refute(assigns(:user).persisted?)
    assert_template(:new)
    assert_template(:partial => "_form")
    assert_response(:success)
  end

  def test_post_create_with_logged_in_user
    user = signed_up_user
    user.activate!
    login_user(user)
    params = {
      :user => {
        :username              => "lisa",
        :email                 => "lisa@example.org",
        :password              => "secret",
        :password_confirmation => "secret"
      }
    }
    assert_no_difference("User.count", 1) do
      post(:create, params)
    end
    assert_nil(assigns(:current_user))
    refute(assigns(:user))
    assert_response(:redirect)
    assert_redirected_to(root_url)
  end

  def test_post_create_with_validation_errors
    params = {
      :user => {
        :username              => "",
        :email                 => "",
        :password              => "",
        :password_confirmation => ""
      }
    }
    assert_no_difference("User.count") do
      post(:create, params)
    end
    assert_instance_of(User, assigns(:user))
    refute(assigns(:user).persisted?)
    assert_nil(flash[:notice])
    assert_template(:new)
    assert_template(:partial => "shared/_errors")
    assert_template(:partial => "_form")
    assert_response(:success)
  end

  def test_post_create
    params = {
      :user => {
        :username              => "lisa",
        :email                 => "lisa@example.org",
        :password              => "secret",
        :password_confirmation => "secret"
      }
    }
    assert_difference("User.count", 1) do
      post(:create, params)
    end
    assert_instance_of(User, assigns(:user))
    assert(assigns(:user).persisted?)
    assert_equal(
      "Signed up! Please check email :)",
      flash[:notice]
    )
    assert_response(:redirect)
    assert_redirected_to(root_url)
  end

  def test_get_activate_with_logged_in_user
    user = signed_up_user
    token = user.activation_token
    user.activate!
    login_user(user)
    expressions = [
      "User.where(:activation_state => \"active\").count",
      "Node.where(:user_id => #{user.id}).count"
    ]
    assert_no_difference(expressions, 1) do
      get(:activate, :token => token)
    end
    assert_nil(assigns(:current_user))
    refute(assigns(:user))
    assert_response(:redirect)
    assert_redirected_to(root_url)
  end

  def test_get_activate_with_invalid_token
    user = signed_up_user
    expressions = [
      "User.where(:activation_state => \"active\").count",
      "Node.where(:user_id => #{user.id}).count"
    ]
    assert_no_difference(expressions, 1) do
      get(:activate, :token => "invalid")
    end
    refute(assigns(:user))
    assert_equal(
      "Invalid token :-p",
      flash[:alert]
    )
    assert_response(:redirect)
    assert_redirected_to(login_url)
  end

  def test_get_activate
    user = signed_up_user
    expressions = [
      "User.where(:activation_state => \"active\").count",
      "Node.where(:user_id => #{user.id}).count"
    ]
    assert_difference(expressions, 1) do
      get(:activate, :token => user.activation_token)
    end
    user.reload
    assert(user.active?)
    assert_equal(
      "Your were successfully activated, Please login :-D",
      flash[:notice]
    )
    assert_response(:redirect)
    assert_redirected_to(login_url)
  end

  # methods

  def test_require_logout_with_logged_in_user
    user = users(:bob)
    login_user(user)
    controller = UsersController.new
    controller.request = request
    response = ActionDispatch::Response.new
    controller.instance_variable_set(:@_response, response)
    assert_equal(user, controller.current_user)

    controller.send(:require_logout)
    assert_equal(false, controller.current_user)
    assert_equal(root_url, response.redirect_url)
  end

  def test_require_logout_with_non_logged_in_user
    controller = UsersController.new
    controller.request = request
    response = ActionDispatch::Response.new
    controller.instance_variable_set(:@_response, response)
    assert_equal(false, controller.current_user)

    controller.send(:require_logout)
    assert_equal(false, controller.current_user)
    assert_equal(nil, response.redirect_url)
  end

  private

    def signed_up_user
      attributes = {
        :username              => "johnsmith",
        :email                 => "john@example.org",
        :password              => "test",
        :password_confirmation => "test",
        :activation_token      => "token",
        :activation_state      => "pending"
      }
      User.create(attributes)
    end
end
