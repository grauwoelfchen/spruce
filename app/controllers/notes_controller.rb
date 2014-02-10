class NotesController < ApplicationController
  before_filter :require_login
  before_filter :load_note, :except => [:index, :new, :create]

  def index
    @notes = Note.visible_to(current_user).order(:updated_at => :desc)
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params).assign_to(current_user)
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
    redirect_to notes_url
  end

  private

  def load_note
    @note = Note.visible_to(current_user).where(:id => params[:id]).first
    redirect_to root_url unless @note
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
