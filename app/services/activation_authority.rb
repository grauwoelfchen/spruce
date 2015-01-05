class ActivationAuthority
  def initialize(token = nil)
    @token = token
  end

  def activate!
    user = User.load_from_activation_token(@token)
    if user
      user.transaction do
        user.activate!
        create_home(user)
      end

      if Rails.application.config.notification[:to]
        notify_about_new_user(user)
      end

      user.active?
    else
      false
    end
  end

  private

  def create_home(user)
    if Node.where(:user => user).first
      false
    else
      home = Node.new.assign_to(user)
      home.save(:validate => false)
    end
  end

  def notify_about_new_user(user)
    NotificationMailer.new_user_email(user).deliver
  end
  handle_asynchronously :notify_about_new_user
end
