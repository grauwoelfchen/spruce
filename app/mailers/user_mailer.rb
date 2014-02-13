class UserMailer < ActionMailer::Base
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def activation_needed_email(user)
    @user = user
    @url  = activate_url(:token => user.activation_token)
    mail :to => user.email, :subject => "Welcome to Spruce"
  end

  def activation_success_email(user)
    @user = user
    @url  = login_url
    mail :to => user.email, :subject => "Your account is now activated"
  end
end
