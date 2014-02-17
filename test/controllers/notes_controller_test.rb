require "test_helper"

class NotesControllerTest < ActionController::TestCase
  fixtures :notes, :users, :nodes

  setup    :login, :initialize_node, :initialize_note
  teardown :logout

  # actions

  def test_get_index_without_nest
    assert_raise ActionController::UrlGenerationError do
      get :index
    end
  end

  def test_get_index_with_others_node
    node = nodes(:bob_s_home)
    get :index, :node_id => node.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_index
    get :index, :node_id => @note.node.id
    assert_response :success
    assert_not_empty assigns(:notes)
    assert_equal [assigns(:current_user)], assigns(:notes).map(&:user).uniq
    assert_template :index
  end

  def test_get_show_with_others_node
    get :show, :id => @note.node.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_show
    get :show, :id => @note
    assert_response :success
    assert_equal @note, assigns(:note)
    assert_template :show
  end

  def test_get_new_without_nest
    assert_raise ActionController::UrlGenerationError do
      get :new
    end
  end

  def test_get_new_with_others_node
    node = nodes(:bob_s_home)
    get :new, :node_id => node.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_new
    get :new, :node_id => @note.node.id
    assert_response :success
    assert_instance_of Note, assigns(:note)
    assert_template :new
    assert_template :partial => "_form"
  end

  def test_post_create_without_nest
    assert_raise ActionController::UrlGenerationError do
      post :create, :note => { :content => "Unknown Note\n\nUnexpected" }
    end
  end

  def test_post_create_with_others_node
    node = nodes(:bob_s_home).children.first
    assert_no_difference("Node.count", 1) do
      post :create, :node_id => node.id, :note => { :content => "Not allowed, right?\r\n" }
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_post_create_with_validation_errors
    assert_no_difference("Note.count", 1) do
      post :create, :node_id => @note.node.id, :note => { :content => "" }
    end
    assert_response :success
    assert_instance_of Note, assigns(:note)
    assert_template :new
    assert_template :partial => "shared/_errors"
    assert_template :partial => "_form"
  end

  def test_post_create
    assert_difference("Note.count", 1) do
      post :create, :node_id => @note.node.id, :note => { :content => "More hard Linux beginner's Book\r\n" }
    end
    assert_response :redirect
    assert_redirected_to note_url(assigns(:note))
  end

  def test_get_edit_with_others_note
    note = notes(:idea_note)
    get :edit, :id => note.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_edit
    get :edit, :id => @note.id
    assert_response :success
    assert_equal @note, assigns(:note)
    assert_template :edit
    assert_template :partial => "_form"
  end

  def test_put_update_with_others_note
    note = notes(:idea_note)
    put :update, :id => note.id, :note => { :content => "Not allowed, right?" }
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_put_update_with_validation_errors
    put :update, :id => @note.id, :note => { :content => "" }
    assert_response :success
    assert_equal @note, assigns(:note)
    assert_template :edit
    assert_template :partial => "shared/_errors"
    assert_template :partial => "_form"
  end

  def test_put_update
    put :update, :id => @note.id, :note => { :content => "Little hard Linux user's Book\r\n" }
    assert_response :redirect
    assert_redirected_to note_url(assigns(:note))
  end

  def test_delete_destroy_with_others_note
    note = notes(:idea_note)
    assert_no_difference("Note.count", -1) do
      delete :destroy, :id => note.id
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_delete_destroy
    assert_difference("Note.count", -1) do
      delete :destroy, :id => @note.id
    end
    assert_response :redirect
    assert_redirected_to node_url(@note.node)
  end

  private

  def login
    user = users(:tim)
    login_user(user)
  end

  def initialize_node
    Node.rebuild!
  end

  def initialize_note
    @note = notes(:linux_book)
    @note.update_attributes(:user => assigns(:current_user))
  end

  def logout
    logout_user
  end
end
