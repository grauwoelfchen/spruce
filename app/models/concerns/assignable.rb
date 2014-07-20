module Assignable
  extend ActiveSupport::Concern

  def assign_to(user)
    self.user_id = user.id
    self
  end

  def user_id_was
    # same as user_id for consistency
    user_id
  end
end

