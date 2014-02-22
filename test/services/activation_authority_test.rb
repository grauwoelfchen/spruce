require "test_helper"

class ActivationAuthorityTest < ActiveSupport::TestCase
  fixtures :users, :nodes

  def test_activate_with_invalid_token
    user = signed_up_user
    assert_no_difference("Node.count", 1) do
      authority = ActivationAuthority.new("invalid")
      assert_not authority.activate!
    end
  end

  def test_activate_with_existing_user
    user = users(:bob)
    assert_no_difference("Node.count", 1) do
      authority = ActivationAuthority.new
      assert_not authority.activate!
    end
  end

  def test_activate
    user = signed_up_user
    assert_difference("Node.count", 1) do
      authority = ActivationAuthority.new(user.activation_token)
      assert authority.activate!
    end
  end

  def test_create_home_with_existing_user
    user = users(:bob)
    assert_no_difference("Node.count", 1) do
      authority = ActivationAuthority.new
      assert_not authority.send(:create_home, user)
    end
  end

  def test_create_home_signed_up_user
    user = signed_up_user
    assert_difference("Node.count", 1) do
      authority = ActivationAuthority.new(user.activation_token)
      assert authority.send(:create_home, user)
    end
  end

  private

  def signed_up_user
    attributes = {
      :username              => "johnsmith",
      :email                 => "grauwoelfchen@gmail.com",
      :password              => "test",
      :password_confirmation => "test",
      :activation_token      => "token",
      :activation_state      => "pending"
    }
    User.create(attributes)
  end
end
