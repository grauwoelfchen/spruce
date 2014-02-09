require "test_helper"

class UsersControllerTest < ActionController::TestCase
  fixtures :users

  def test_new_user
    get :new
    assert_response :success
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
    post :create, attributes
    assert_response :success
    assert_template :new
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
    post :create, attributes
    assert_response :redirect
    assert_redirected_to login_url
  end
end
