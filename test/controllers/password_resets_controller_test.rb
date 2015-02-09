require "test_helper"

class PasswordResetsControllerTest < ActionController::TestCase
  fixtures(:users)

  setup(:initialize_user)

  # actions

  def test_get_new
    get(:new)

    assert_instance_of(User, assigns(:user))
    refute(assigns(:user).persisted?)
    assert_template(:new)
    assert_response(:success)
  end

  def test_post_create_with_validation_errors
    params = {
      :user => {
        :email => @user.email.gsub(/\.org$/, "")
      }
    }
    post(:create, params)

    assert_instance_of(User, assigns(:user))
    refute(assigns(:user).persisted?)
    assert_empty(flash)
    assert_template(:new)
    assert_template(:partial => "shared/_errors")
    assert_response(:success)
  end

  def test_post_create_with_invalid_email
    params = {
      :user => {
        :email => @user.email.gsub(/org$/, "com")
      }
    }
    post(:create, params)

    refute(assigns(:user))
    assert_equal( # show always
      "Instructions have been sent to your email :)",
      flash[:notice]
    )
    assert_response(:redirect)
    assert_redirected_to(root_url)
  end

  def test_post_create
    mailer = Minitest::Mock.new
    mailer.expect(:reset_password_email, true, [Object])
    mailer.expect(:delay, mailer)
    User.sorcery_config.reset_password_mailer = mailer

    params = {
      :user => {
        :email => @user.email
      }
    }
    post(:create, params)
    mailer.verify

    assert_equal(@user, assigns(:user))
    assert_equal(
      "Instructions have been sent to your email :)",
      flash[:notice]
    )
    assert_response(:redirect)
    assert_redirected_to(root_url)
  end

  def test_get_edit_with_invalid_token
    get(:edit, :token => "invalid")

    assert_equal(false, assigns(:current_user))
    refute(assigns(:user))
    assert_equal("invalid", assigns(:token))
    assert_equal(
      "Invalid token :-p",
      flash[:alert]
    )
    assert_response(:redirect)
    assert_redirected_to(login_url)
  end

  def test_get_edit
    get(:edit, :token => @user.reset_password_token)

    assert_equal(false, assigns(:current_user))
    assert_equal(@user, assigns(:user))
    assert_equal(@user.reset_password_token, assigns(:token))
    assert_template(:edit)
    assert_response(:success)
  end

  def test_put_update_with_invalid_token
    params = {
      :token => "invalid",
      :user  => {
        :password              => "secret",
        :password_confirmation => "secret"
      }
    }

    assert_no_difference(
      "User.where(:reset_password_token => nil).count", 1) do
      put(:update, params)
    end

    assert_response(:redirect)
    assert_redirected_to(login_url)
  end

  def test_put_update_with_validation_errors
    params = {
      :token => @user.reset_password_token,
      :user  => {
        :passowrd              => "",
        :password_confirmation => ""
      }
    }

    assert_no_difference(
      "User.where(:reset_password_token => nil).count", 1) do
      put(:update, params)
    end

    assert_equal(@user, assigns(:user))
    assert_template(:edit)
    assert_template(:partial => "shared/_errors")
    assert_response(:success)
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
      put(:update, params)
    end

    assert_response(:redirect)
    assert_redirected_to(root_url)
  end

  # methods

  def test_load_user_from_token_with_invalid_token
    controller = PasswordResetsController.new
    controller.request = request
    controller.params[:token] = "invalid"
    response = ActionDispatch::Response.new
    controller.instance_variable_set(:@_response, response)
    controller.send(:load_user_from_token)

    assert_equal(false, controller.current_user)
    assert_equal(
      "invalid",
      controller.instance_variable_get(:@token)
    )
    assert_nil(controller.instance_variable_get(:@user))
    assert_equal(
      "Invalid token :-p",
      flash[:alert]
    )
    assert_equal(302, controller.status)
    assert_equal(login_url, response.redirect_url)
  end

  def test_load_user_from_token_with_valid_token
    controller = PasswordResetsController.new
    controller.request = request
    controller.params[:token] = @user.reset_password_token
    response = ActionDispatch::Response.new
    controller.instance_variable_set(:@_response, response)
    controller.send(:load_user_from_token)

    assert_equal(false, controller.current_user)
    assert_equal(
      @user.reset_password_token,
      controller.instance_variable_get(:@token)
    )
    assert_equal(@user, controller.instance_variable_get(:@user))
    assert_empty(flash)
  end

  private

    def initialize_user
      @user = users(:tim)
      @user.update_attribute(:reset_password_token, "token")
    end
end
