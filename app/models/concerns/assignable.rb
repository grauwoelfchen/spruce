module Assignable
  extend ActiveSupport::Concern

  def assign_to(user)
    self.user_id = user.id
    self
  end
end

