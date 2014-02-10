require "test_helper"

class UserTest < ActiveSupport::TestCase
  fixtures :users

  # properties

  def test_properties
    user = User.new
    assert_respond_to user, :username
    assert_respond_to user, :crypted_password
    assert_respond_to user, :email
    assert_respond_to user, :salt
    assert_respond_to user, :remember_me_token
    assert_respond_to user, :remember_me_token_expires_at
    assert_respond_to user, :reset_password_token
    assert_respond_to user, :reset_password_token_expires_at
    assert_respond_to user, :reset_password_email_sent_at
    assert_respond_to user, :activation_state
    assert_respond_to user, :activation_token
    assert_respond_to user, :activation_token_expires_at
  end

  # validations

  def test_validation_with_blank_username
    user = User.new(:username => "")
    user.valid?
    assert_equal 1, user.errors[:username].length
    assert_equal "can't be blank", user.errors[:username].first
  end

  def test_validation_with_invalid_username
    user = User.new(:username => "!INVALID!")
    user.valid?
    assert_equal 1, user.errors[:username].length
    assert_equal "must be `/^[a-z0-9-_]+$/`", user.errors[:username].first
  end

  def test_validation_with_too_short_username
    user = User.new(:username => "t")
    user.valid?
    assert_equal 1, user.errors[:username].length
    assert_equal "is too short (minimum is 3 characters)", user.errors[:username].first
  end

  def test_validation_with_too_long_username
    user = User.new(:username => "testtesttesttesttesttest")
    user.valid?
    assert_equal 1, user.errors[:username].length
    assert_equal "is too long (maximum is 18 characters)", user.errors[:username].first
  end

  def test_validation_with_existing_username
    existing_user = users(:tim)
    user = User.new(:username => existing_user.username)
    user.valid?
    assert_equal 1, user.errors[:username].length
    assert_equal "has already been taken", user.errors[:username].first
  end

  def test_validation_with_blank_email
    user = User.new(:email => "")
    user.valid?
    assert_equal 1, user.errors[:email].length
    assert_equal "can't be blank", user.errors[:email].first
  end

  def test_validation_with_invalid_email
    user = User.new(:email => "t@t.t")
    user.valid?
    assert_equal 1, user.errors[:email].length
    assert_equal "is invalid", user.errors[:email].first
  end

  def test_validation_with_too_long_email
    user = User.new(:email => ("long" * 100) + "@example.com")
    user.valid?
    assert_equal 1, user.errors[:email].length
    assert_equal "is too long (maximum is 64 characters)", user.errors[:email].first
  end

  def test_validation_with_existing_email
    existing_user = users(:tim)
    user = User.new(:email => existing_user.email)
    user.valid?
    assert_equal 1, user.errors[:email].length
    assert_equal "has already been taken", user.errors[:email].first
  end

  def test_validation_with_blank_password
    user = User.new(:password => "")
    user.valid?
    assert_equal(1, user.errors[:password].length)
    assert_equal("can't be blank", user.errors[:password].first)
  end

  def test_validation_with_too_short_password
    user = User.new(:password => "s")
    user.valid?
    assert_equal 1, user.errors[:password].length
    assert_equal "is too short (minimum is 4 characters)", user.errors[:password].first
  end

  def test_validation_with_blank_password_confirmation
    user = User.new(:password => "", :password_confirmation => "")
    user.valid?
    assert_equal 1, user.errors[:password_confirmation].length
    assert_equal "can't be blank", user.errors[:password_confirmation].first
  end

  def test_validation_with_not_matched_password_confirmation
    user = User.new(:password => "foo", :password_confirmation => "bar")
    user.valid?
    assert_equal 1, user.errors[:password_confirmation].length
    assert_equal "doesn't match Password", user.errors[:password_confirmation].first
  end

  # save & update

  def test_save_with_errors
    user = User.new
    assert_not user.save, "Saved the user with errors"
  end

  def test_save_without_errors
    attributes = {
      :username              => "lisa",
      :email                 => "lisa@example.com",
      :password              => "secret",
      :password_confirmation => "secret"
    }
    user = User.new(attributes)
    assert user.save, "Failed to save the user without errors"
  end

  def test_update_with_errors
    user = users(:tim)
    assert_not user.update_attributes(:username => ""), "Updated the user with errors"
  end

  def test_update_without_errors
    attributes = {
      :email                 => "tim-s-new-email@example.com",
      :password              => "secret",
      :password_confirmation => "secret"
    }
    user = users(:tim)
    assert user.update_attributes(attributes), "Failed to update the user without errors"
  end
end
