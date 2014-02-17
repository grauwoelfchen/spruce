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
    user.valid?
    assert_equal ["can't be blank"], user.errors[:username]
  end

  def test_validation_with_invalid_username
    user = User.new(:username => "!INVALID!")
    user.valid?
    assert_equal ["must be alphanumeric characters and _"], user.errors[:username]
  end

  def test_validation_with_too_short_username
    user = User.new(:username => "t")
    user.valid?
    assert_equal ["is too short (minimum is 3 characters)"], user.errors[:username]
  end

  def test_validation_with_too_long_username
    user = User.new(:username => "testtesttesttesttesttest")
    user.valid?
    assert_equal ["is too long (maximum is 18 characters)"], user.errors[:username]
  end

  def test_validation_with_existing_username
    existing_user = users(:tim)
    user = User.new(:username => existing_user.username)
    user.valid?
    assert_equal ["has already been taken"], user.errors[:username]
  end

  def test_validation_with_blank_email
    user = User.new(:email => "")
    user.valid?
    assert_equal ["can't be blank"], user.errors[:email]
  end

  def test_validation_with_invalid_email
    user = User.new(:email => "t@t.t")
    user.valid?
    assert_equal ["is invalid"], user.errors[:email]
  end

  def test_validation_with_too_long_email
    user = User.new(:email => ("long" * 100) + "@example.com")
    user.valid?
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
    user.valid?
    assert_equal ["can't be blank"], user.errors[:password]
  end

  def test_validation_with_too_short_password
    user = User.new(:password => "s")
    user.valid?
    assert_equal ["is too short (minimum is 4 characters)"], user.errors[:password]
  end

  def test_validation_with_blank_password_confirmation
    user = User.new(:password => "", :password_confirmation => "")
    user.valid?
    assert_equal ["can't be blank"], user.errors[:password_confirmation]
  end

  def test_validation_with_not_matched_password_confirmation
    user = User.new(:password => "foo", :password_confirmation => "bar")
    user.valid?
    assert_equal ["doesn't match Password"], user.errors[:password_confirmation]
  end

  # save & update

  def test_save_with_errors
    user = User.new
    assert_not user.save
  end

  def test_save_without_errors
    attributes = {
      :username              => "lisa",
      :email                 => "lisa@example.com",
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
      :email                 => "tim-s-new-email@example.com",
      :password              => "secret",
      :password_confirmation => "secret"
    }
    user = users(:tim)
    assert user.update_attributes(attributes)
  end

  # delete & destroy

  def test_delete
    user = users(:bob)
    user.delete
    assert_nil User.where(:id => user.id).first
    assert Node.where(:user => user).present?
    assert Note.where(:user => user).present?
  end

  def test_destroy
    user = users(:bob)
    user.destroy
    assert_nil User.where(:id => user.id).first
    assert Node.where(:user => user).present?
    assert Note.where(:user => user).present?
  end

  # methods

  def test_create_home_with_existed_user
    user = users(:bob)
    assert_no_difference("Node.count", 1) do
      user.create_home!
    end
  end

  def test_create_home_signed_up_user
    user = signed_up_user
    assert_difference("Node.count", 1) do
      user.create_home!
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
