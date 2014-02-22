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
end
