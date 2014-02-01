require "test_helper"

class NotesControllerTest < ActionController::TestCase
  fixtures :notes

  setup :initialize_note

  # actions

  def test_get_index
    get :index
    assert_response :success
    assert_not_empty assigns(:notes)
  end

  def test_show_note
    get :show, :id => @note
    assert_response :success
    assert_equal @note, assigns(:note)
  end

  def test_new_note
    get :new
    assert_response :success
    assert_instance_of Note, assigns(:note)
  end

  def test_create_note
    post :create, :note => { :content => "More hard Linux beginner's Book\r\n" }
  end

  def test_edit_note
    get :edit, :id => @note.id
    assert_response :success
    assert_equal @note, assigns(:note)
  end

  def test_update_note
    patch :update, :id => @note.id, :note => { :content => "Little hard Linux user's Book\r\n" }
    assert_response :redirect
    assert_redirected_to note_path(assigns(:note))
  end

  def test_destroy_note
    assert_difference("Note.count", -1) do
      delete :destroy, :id => @note.id
    end
    assert_redirected_to notes_path
  end

  private

  def initialize_note
    @note = notes(:linux_book)
  end
end
