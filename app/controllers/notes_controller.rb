class NotesController < ApplicationController
  include ParentNodeManagement

  before_filter :require_login
  before_filter :load_note, :except => [:new, :create]
  before_filter :load_node, :except => [:destroy]

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params).assign_to(current_user)
    @note.node = @node
    if @note.save
      redirect_to @note
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @note.update_attributes(note_params)
      redirect_to @note
    else
      render :edit
    end
  end

  def destroy
    @note.destroy
    redirect_to node_url(@note.node)
  end

  private

  def load_note
    @note = Note.visible_to(current_user).where(:id => params[:id]).first
    redirect_to root_url unless @note
  end

  def load_node
    @node = \
      if params[:node_id]
        load_parent_node(params[:node_id])
      elsif @note
        @note.node
      end
    redirect_to root_url unless @node
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
