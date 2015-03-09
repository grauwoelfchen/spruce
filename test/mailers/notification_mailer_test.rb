require "test_helper"

class NotificationMailerTest < ActionMailer::TestCase
  fixtures(:users)

  setup(:initialize_user)

  def test_new_user_email
    mail = NotificationMailer.new_user_email(@user)

    assert_equal("New user joined", mail.subject)
    assert_equal(["notification-to@example.org"], mail.to)
    assert_equal(["notification-from@example.org"], mail.from)
    assert_match("New user #{@user.username} has joined", mail.body.encoded)
  end

  private

  def initialize_user
    @user = users(:oswald)
  end
end
