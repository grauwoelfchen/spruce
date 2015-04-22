module Visible
  extend ActiveSupport::Concern

  module ClassMethods
    def visible_to(user)
      where("#{table_name}.user_id = ?", user.id)
    end

    def with_scoped_to
      m = /^#{table_name}\.user\_id\s\=\s(\d+)$/.match(all.where_values.reduce(:and))
      unless m && m[1]
        raise ActiveRecord::RecordNotFound
      end
      yield(m[1])
    end
  end
end
