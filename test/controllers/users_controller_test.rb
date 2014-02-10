require "test_helper"

class UsersControllerTest < ActionController::TestCase
  fixtures :users

  def test_new_user
    get :new
    assert_response :success
    assert_instance_of User, assigns(:user)
    assert_template :new
    assert_template :partial => "_form"
  end

  def test_create_user_with_validation_errors
    attributes = {
      :user => {
        :username              => "",
        :email                 => "",
        :password              => "",
        :password_confirmation => ""
      }
    }
    assert_no_difference("User.count") do
      post :create, attributes
    end
    assert_response :success
    assert_template :new
    assert_template :partial => "shared/_errors"
    assert_template :partial => "_form"
  end

  def test_create_user
    attributes = {
      :user => {
        :username              => "lisa",
        :email                 => "lisa@example.com",
        :password              => "secret",
        :password_confirmation => "secret"
      }
    }
    assert_difference("User.count", 1) do
      post :create, attributes
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  def test_activate_user_with_invalid_token
    @user = users(:tim)
    @user.update_attribute(:activation_token, "token")
    attributes = {
      :token => "invalid"
    }
    assert_no_difference("User.where(:activation_state => \"active\").count") do
      get :activate, attributes 
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  def test_activate_user
    @user = users(:tim)
    @user.update_attribute(:activation_token, "token")
    attributes = {
      :token => @user.activation_token
    }
    assert_difference("User.where(:activation_state => \"active\").count", 1) do
      get :activate, attributes 
    end
    assert_response :redirect
    assert_redirected_to notes_url
  end
end
