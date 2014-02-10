require "test_helper"

class NotesControllerTest < ActionController::TestCase
  fixtures :notes, :users

  setup    :login, :initialize_note
  teardown :logout

  # actions

  def test_get_index
    get :index
    assert_response :success
    assert_not_empty assigns(:notes)
    assert_equal 1, assigns(:notes).map(&:user_id).uniq.length
    assert_equal assigns(:current_user).id, assigns(:notes).map(&:user_id).uniq.first
    assert_template :index
  end

  def test_show_note
    get :show, :id => @note
    assert_response :success
    assert_equal @note, assigns(:note)
    assert_template :show
  end

  def test_new_note
    get :new
    assert_response :success
    assert_instance_of Note, assigns(:note)
    assert_template :new
    assert_template :partial => "_form"
  end

  def test_create_note_with_validation_errors
    assert_no_difference("Note.count") do
      post :create, :note => { :content => "" }
    end
    assert_response :success
    assert_instance_of Note, assigns(:note)
    assert_template :new
    assert_template :partial => "shared/_errors"
    assert_template :partial => "_form"
  end

  def test_create_note
    assert_difference("Note.count", 1) do
      post :create, :note => { :content => "More hard Linux beginner's Book\r\n" }
    end
    assert_response :redirect
    assert_redirected_to note_url(assigns(:note))
  end

  def test_edit_note
    get :edit, :id => @note.id
    assert_response :success
    assert_equal @note, assigns(:note)
    assert_template :edit
    assert_template :partial => "_form"
  end

  def test_update_note_with_validation_errors
    patch :update, :id => @note.id, :note => { :content => "" }
    assert_response :success
    assert_equal @note, assigns(:note)
    assert_template :edit
    assert_template :partial => "shared/_errors"
    assert_template :partial => "_form"
  end

  def test_update_note_of_others
    other = users(:bob)
    other_s_note = notes(:shopping_list)
    other_s_note.update_attribute(:user, other)
    assert_no_difference("Note.count", -1) do
      patch :update, :id => other_s_note.id, :note => { :content => "Not allowed, right?" }
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_update_note
    patch :update, :id => @note.id, :note => { :content => "Little hard Linux user's Book\r\n" }
    assert_response :redirect
    assert_redirected_to note_url(assigns(:note))
  end

  def test_destroy_note_of_others
    other = users(:bob)
    other_s_note = notes(:shopping_list)
    other_s_note.update_attribute(:user, other)
    assert_no_difference("Note.count", -1) do
      delete :destroy, :id => other_s_note.id
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_destroy_note
    assert_difference("Note.count", -1) do
      delete :destroy, :id => @note.id
    end
    assert_response :redirect
    assert_redirected_to notes_url
  end

  private

  def login
    user = users(:tim)
    login_user(user)
  end

  def initialize_note
    @note = notes(:linux_book)
    @note.update_attributes(:user => assigns(:current_user))
  end

  def logout
    logout_user
  end
end
