class PagesController < ApplicationController
  def index
   @root = Node.visible_to(current_user).root if current_user
  end
end
