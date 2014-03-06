require "test_helper"

class UsersControllerTest < ActionController::TestCase
  fixtures :users

  def test_get_new
    get :new
    assert_response :success
    assert_instance_of User, assigns(:user)
    assert_template :new
    assert_template :partial => "_form"
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
      post :create, params
    end
    assert_response :success
    assert_template :new
    assert_template :partial => "shared/_errors"
    assert_template :partial => "_form"
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
      post :create, params
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_activate_with_invalid_token
    user = signed_up_user
    expressions = [
      "User.where(:activation_state => \"active\").count",
      "Node.where(:user_id => #{user.id}).count"
    ]
    assert_no_difference(expressions, 1) do
      get :activate, :token => "invalid"
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  def test_get_activate
    user = signed_up_user
    expressions = [
      "User.where(:activation_state => \"active\").count",
      "Node.where(:user_id => #{user.id}).count"
    ]
    assert_difference(expressions, 1) do
      get :activate, :token => user.activation_token
    end
    assert_response :redirect
    assert_redirected_to login_url
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
