require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  fixtures(:users)

  setup(:initialize_user)

  def test_reset_password_email
    @user.reset_password_token = "token"
    mail = UserMailer.reset_password_email(@user)

    assert_equal("Your password has been reset", mail.subject)
    assert_equal([@user.email], mail.to)
    assert_equal(["from@example.org"], mail.from)
    assert_match("Hi, #{@user.username}", mail.body.encoded)
  end

  def test_activation_needed_email
    @user.activation_token = "token"
    mail = UserMailer.activation_needed_email(@user)

    assert_equal("Welcome to Spruce", mail.subject)
    assert_equal([@user.email], mail.to)
    assert_equal(["from@example.org"], mail.from)
    assert_match("Welcome to Spruce, #{@user.username}", mail.body.encoded)
  end

  def test_activation_success_email
    mail = UserMailer.activation_success_email(@user)

    assert_equal("Your account is now activated", mail.subject)
    assert_equal([@user.email], mail.to)
    assert_equal(["from@example.org"], mail.from)
    assert_match("Congratulations, #{@user.username}", mail.body.encoded)
  end

  private

  def initialize_user
    @user = users(:oswald)
  end
end
