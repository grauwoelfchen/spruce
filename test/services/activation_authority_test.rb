require "test_helper"

class ActivationAuthorityTest < ActiveSupport::TestCase
  fixtures(:users, :nodes)

  def test_activate_with_invalid_token
    user = signed_up_user

    assert_no_difference("Node.count", 1) do
      authority = ActivationAuthority.new("invalid")
      refute(authority.activate!)
    end
  end

  def test_activate_with_existing_user
    user = users(:weenie)

    assert_no_difference("Node.count", 1) do
      authority = ActivationAuthority.new
      refute(authority.activate!)
    end
  end

  def test_activate
    user = signed_up_user
    mail = Minitest::Mock.new
    mail.expect(:deliver, true)

    NotificationMailer.stub(:new_user_email, mail) do
      assert_difference("Node.count", 1) do
        authority = ActivationAuthority.new(user.activation_token)
        assert(authority.activate!)
        mail.verify
      end
    end
  end

  def test_create_home_with_existing_user
    user = users(:weenie)

    assert_no_difference("Node.count", 1) do
      authority = ActivationAuthority.new
      refute_nil(authority.send(:create_home, user))
    end
  end

  def test_create_home_signed_up_user
    user = signed_up_user

    assert_difference("Node.count", 1) do
      authority = ActivationAuthority.new(user.activation_token)
      refute_nil(authority.send(:create_home, user))
    end
  end

  def test_notify_about_new_user
    user = signed_up_user
    mail = Minitest::Mock.new
    mail.expect(:deliver, true)

    NotificationMailer.stub(:new_user_email, mail) do
      authority = ActivationAuthority.new(user.activation_token)
      authority.send(:notify_about_new_user, user)
      mail.verify
    end
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
