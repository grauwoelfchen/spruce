class NodesController < ApplicationController
  include ParentNodeManagement

  before_filter :require_login
  before_filter :load_node, :except => [:index, :new, :create]
  before_filter :load_parent, :only => [:new, :create]
  before_filter :block_root, :only => [:edit, :update, :delete, :destroy]

  def index
    @node = Node.visible_to(current_user).cached_root
  end

  def show
    respond_to do |format|
      format.html
      format.text { render :layout => false }
      if request.xhr?
        format.js { render :layout => false }
      end
    end
  end

  def new
    @node = @parent.children.build
  end

  def create
    @node = Node.new(node_params).assign_to(current_user)
    @node.parent = @parent
    if @node.save
      redirect_to node_url(@node.parent),
        :notice => "Successfully created branch. #{undo_link}"
    else
      render :new
    end
  end

  def edit
  end

  def update
    recorder = ChangeRecorder.new(@node)
    if recorder.update_attributes(node_params)
      redirect_to @node,
        :notice => "Successfully updated branch. #{undo_link}"
    else
      render :edit
    end
  end

  def delete
    render :layout => "application.min"
  end

  def destroy
    @node.destroy
    redirect_to nodes_url,
      :notice => "Successfully destroyed branch. #{undo_link}"
  end

  private

    def load_node
      @node = Node.visible_to(current_user).cached_find(params[:id])
    end

    def load_parent
      @parent = load_parent_node(params[:node_id])
    end

    def block_root
      redirect_to nodes_url if @node.root?
    end

    def node_params
      params.require(:node).permit(:name)
    end

    def undo_link
      view_context.link_to "undo",
        revert_version_path(@node.versions.last, "b"), :method => :post
    end
end
