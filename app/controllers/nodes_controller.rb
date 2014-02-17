class NodesController < ApplicationController
  before_filter :require_login
  before_filter :load_parent, :only => [:index, :new, :create]
  before_filter :load_node, :except => [:index, :new, :create]

  def index
    @node = @parent || Node.visible_to(current_user).root
    redirect_to root_url unless @node
  end

  def show
  end

  def new
    @node = @parent.children.build
  end

  def create
    @node = Node.new(node_params).assign_to(current_user)
    @node.parent = @parent
    if @node.valid? && @parent.add_child(@node)
      redirect_to node_nodes_url(@node.parent)
    else
      render :new
    end
  end

  def edit
    redirect_to node_nodes_url(@node) if @node.root?
  end

  def update
    redirect_to node_nodes_url(@node) if @node.root?
    if @node.update_attributes(node_params)
      redirect_to @node
    else
      render :edit
    end
  end

  def destroy
    @node.destroy unless @node.root?
    redirect_to nodes_url
  end

  private

  def load_node
    @node = Node.visible_to(current_user).where(:id => params[:id]).first
    redirect_to root_url unless @node
  end

  def load_parent
    if params[:node_id]
      @parent = Node.visible_to(current_user).where(:id => params[:node_id]).first
      redirect_to root_url unless @parent
    end
  end

  def node_params
    params.require(:node).permit(:name)
  end
end
