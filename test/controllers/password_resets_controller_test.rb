require "test_helper"

class PasswordResetsControllerTest < ActionController::TestCase
  fixtures :users

  setup :initialize_user

  def test_get_edit_with_invalid_token
    get :edit, :token => "invalid"
    assert_response :redirect
    assert_redirected_to login_url
  end

  def test_get_edit
    get :edit, :token => @user.reset_password_token
    assert_response :success
    assert_equal @user, assigns(:user)
    assert_template :edit
  end

  def test_put_update_with_invalid_token
    params = {
      :token => "invalid",
      :user  => {
        :password              => "secret",
        :password_confirmation => "secret"
      }
    }
    assert_no_difference("User.where(:reset_password_token => nil).count", 1) do
      put :update, params
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  def test_put_update_with_validation_errors
    params = {
      :token => @user.reset_password_token,
      :user  => {
        :passowrd              => "",
        :password_confirmation => ""
      }
    }
    assert_no_difference("User.where(:reset_password_token => nil).count", 1) do
      put :update, params
    end
    assert_response :success
    assert_equal @user, assigns(:user)
    assert_template :edit
    assert_template :partial => "shared/_errors"
  end

  def test_put_update
    params = {
      :token => @user.reset_password_token,
      :user  => {
        :password              => "secret",
        :password_confirmation => "secret"
      }
    }
    assert_difference("User.where(:reset_password_token => nil).count", 1) do
      put :update, params
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  private

  def initialize_user
    @user = users(:tim)
    @user.update_attribute(:reset_password_token, "token")
  end
end
