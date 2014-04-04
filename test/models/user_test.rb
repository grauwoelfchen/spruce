require "test_helper"

class UserTest < ActiveSupport::TestCase
  fixtures :users, :nodes, :notes

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

  # associations

  def test_associations
    user = User.new
    assert_respond_to user, :notes
  end

  # validations

  def test_validation_with_blank_username
    user = User.new(:username => "")
    assert_not user.valid?
    assert_equal ["can't be blank"], user.errors[:username]
  end

  def test_validation_with_invalid_username
    user = User.new(:username => "!INVALID!")
    assert_not user.valid?
    assert_equal ["must be alphanumeric characters and _"], user.errors[:username]
  end

  def test_validation_with_too_short_username
    user = User.new(:username => "t")
    assert_not user.valid?
    assert_equal ["is too short (minimum is 3 characters)"], user.errors[:username]
  end

  def test_validation_with_too_long_username
    user = User.new(:username => "testtesttesttesttesttest")
    assert_not user.valid?
    assert_equal ["is too long (maximum is 18 characters)"], user.errors[:username]
  end

  def test_validation_with_existing_username
    existing_user = users(:tim)
    user = User.new(:username => existing_user.username)
    assert_not user.valid?
    assert_equal ["has already been taken"], user.errors[:username]
  end

  def test_validation_with_blank_email
    user = User.new(:email => "")
    assert_not user.valid?
    assert_equal ["can't be blank"], user.errors[:email]
  end

  def test_validation_with_invalid_email
    user = User.new(:email => "t@t.t")
    assert_not user.valid?
    assert_equal ["is invalid"], user.errors[:email]
  end

  def test_validation_with_too_long_email
    user = User.new(:email => ("long" * 100) + "@example.org")
    assert_not user.valid?
    assert_equal ["is too long (maximum is 64 characters)"], user.errors[:email]
  end

  def test_validation_with_existing_email
    existing_user = users(:tim)
    user = User.new(:email => existing_user.email)
    user.valid?
    assert_equal ["has already been taken"], user.errors[:email]
  end

  def test_validation_with_blank_password
    user = User.new(:password => "")
    assert_not user.valid?
    assert_equal ["can't be blank"], user.errors[:password]
  end

  def test_validation_with_too_short_password
    user = User.new(:password => "s")
    assert_not user.valid?
    assert_equal ["is too short (minimum is 4 characters)"], user.errors[:password]
  end

  def test_validation_with_blank_password_confirmation
    user = User.new(:password => "", :password_confirmation => "")
    assert_not user.valid?
    assert_equal ["can't be blank"], user.errors[:password_confirmation]
  end

  def test_validation_with_not_matched_password_confirmation
    user = User.new(:password => "foo", :password_confirmation => "bar")
    assert_not user.valid?
    assert_equal ["doesn't match Password"], user.errors[:password_confirmation]
  end

  # actions

  def test_save_with_errors
    user = User.new
    assert_not user.save
  end

  def test_save_without_errors
    attributes = {
      :username              => "lisa",
      :email                 => "lisa@example.org",
      :password              => "secret",
      :password_confirmation => "secret"
    }
    user = User.new(attributes)
    assert user.save
  end

  def test_update_with_errors
    user = users(:tim)
    assert_not user.update_attributes(:username => "")
  end

  def test_update_without_errors
    attributes = {
      :email                 => "tim-s-new-email@example.org",
      :password              => "secret",
      :password_confirmation => "secret"
    }
    user = users(:tim)
    assert user.update_attributes(attributes)
  end

  def test_delete
    user = users(:bob)
    assert user.delete
    assert_nil User.where(:id => user.id).first
    assert Node.where(:user => user).present?
    assert Note.where(:user => user).present?
  end

  def test_destroy
    user = users(:bob)
    assert user.destroy
    assert_nil User.where(:id => user.id).first
    assert Node.where(:user => user).present?
    assert Note.where(:user => user).present?
  end

  # methods

  def test_active_with_pending
    attributes = {
      :activation_state      => "pending",
      :password              => "secret",
      :password_confirmation => "secret"
    }
    user = users(:bob)
    assert user.update_attributes(attributes)
    assert_not user.active?
  end

  def test_active_with_active
    attributes = {
      :activation_state      => "active",
      :password              => "secret",
      :password_confirmation => "secret"
    }
    user = users(:bob)
    assert user.update_attributes(attributes)
    assert user.active?
  end
end
