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
      redirect_to @note, :notice => "Successfully created leaf. #{undo_link}"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    recorder = ChangeRecorder.new(@note)
    if recorder.update_attributes(note_params)
      redirect_to @note, :notice => "Successfully updated leaf. #{undo_link}"
    else
      render :edit
    end
  end

  def delete
    render :layout => "minimal"
  end

  def destroy
    @note.destroy
    redirect_to node_url(@note.node), :notice => "Successfully destroyed leaf. #{undo_link}"
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

  def undo_link
    view_context.link_to("undo", revert_version_path(@note.versions.last, "l"), :method => :post)
  end
end
