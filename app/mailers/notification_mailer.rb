class NotificationMailer < ActionMailer::Base
  def new_user_email(user)
    @user = user
    mail \
      :to      => Rails.application.config.notification[:to],
      :from    => Rails.application.config.notification[:from],
      :subject => "New user joined"
  end
end
