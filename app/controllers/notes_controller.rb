class NotesController < ApplicationController
  before_filter :load_note, :except => [:index, :new, :create]

  def index
    @notes = Note.all
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
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

  def delete
    @note.destroy
    redirect_to notes_path
  end

  private

  def load_note
    @note = Note.where(:id => params[:id]).first
    redirect_to root_path unless @note
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
