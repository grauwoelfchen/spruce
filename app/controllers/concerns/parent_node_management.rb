require "active_support/concern"

module ParentNodeManagement
  extend ActiveSupport::Concern

  included do |klass|
    def load_parent_node(node_id)
      Node.visible_to(current_user).cached_find(node_id)
    end
  end
end
