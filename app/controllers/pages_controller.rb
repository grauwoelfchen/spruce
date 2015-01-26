class PagesController < ApplicationController
  def index
   @root = Node.visible_to(current_user).cached_root if current_user
  end

  def introduction
  end

  def changelog
  end
end
