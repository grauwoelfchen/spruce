class NodesController < ApplicationController
  before_filter :require_login
  before_filter :load_node, :except => [:index, :new, :create]

  def index
    @nodes = Node.visible_to(current_user).roots
  end

  def show
  end

  def new
  end

  def edit
  end

  private

  def load_node
    @node = Node.visible_to(current_user).where(:id => params[:id]).first
    redirect_to root_url unless @node
  end

  def note_params
    params.require(:node).permit(:name, :parent_id)
  end
end
