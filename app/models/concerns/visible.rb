module Visible
  extend ActiveSupport::Concern

  module ClassMethods
    def visible_to(user)
      where("#{table_name}.user_id = ?", user.id)
    end
  end
end
