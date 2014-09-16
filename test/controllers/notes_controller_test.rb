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
    assert_raise ActionController::UrlGenerationError do
      node = nodes(:bob_s_home)
      get :index, :node_id => node.id
    end
  end

  def test_get_index
    assert_raise ActionController::UrlGenerationError do
      get :index, :node_id => @note.node.id
    end
  end

  def test_get_show_with_others_note
    bob_s_note = notes(:idea_note)
    get :show, :id => bob_s_note.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_show
    get :show, :id => @note.id
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
      post :create, :note => {:content => "* Unknown Note\r\n* Unexpected"}
    end
  end

  def test_post_create_with_others_node
    node = nodes(:bob_s_home)
    params = {
      :node_id => node.id,
      :note    => {
        :content => "Not allowed, right?\r\n"
      }
    }
    assert_no_difference "Node.count", 1 do
      post :create, params
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_post_create_with_validation_errors
    params = {
      :node_id => @note.node.id,
      :note    => {
        :content => ""
      }
    }
    assert_no_difference "Note.count", 1 do
      post :create, params
    end
    assert_response :success
    assert_instance_of Note, assigns(:note)
    assert_template :new
    assert_template :partial => "shared/_errors"
    assert_template :partial => "_form"
  end

  def test_post_create
    params = {
      :node_id => @note.node.id,
      :note    => {
        :content => "* More Hard Linux beginner's Book\r\n"
      }
    }
    assert_difference "Note.count", 1 do
      post :create, params
    end
    assert_response :redirect
    assert_redirected_to note_url(assigns(:note))
    assert_equal \
      "Successfully created leaf. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
  end

  def test_get_edit_with_others_note
    bob_s_note = notes(:idea_note)
    get :edit, :id => bob_s_note.id
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
    bob_s_note = notes(:idea_note)
    params = {
      :id   => bob_s_note.id,
      :note => {
        :content => "Not allowed, right?"
      }
    }
    put :update, params
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_put_update_with_validation_errors
    put :update, :id => @note.id, :note => {:content => ""}
    assert_response :success
    assert_equal @note, assigns(:note)
    assert_template :edit
    assert_template :partial => "shared/_errors"
    assert_template :partial => "_form"
  end

  def test_put_update
    params = {
      :id   => @note.id,
      :note => {
        :content => "* Little Hard Linux user's Book\r\n* Getting Started"
      }
    }
    put :update, params
    assert_response :redirect
    assert_redirected_to note_url(assigns(:note))
    assert_equal \
      "Successfully updated leaf. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
  end

  def test_get_delete_with_others_note
    bob_s_note = notes(:idea_note)
    get :delete, :id => bob_s_note.id
    assert_response :redirect
  end

  def test_get_delete
    get :delete, :id => @note.id
    assert_response :success
    assert_equal @note, assigns(:note)
    assert_template :delete
  end

  def test_delete_destroy_with_others_note
    bob_s_note = notes(:idea_note)
    assert_no_difference "Note.count", -1 do
      delete :destroy, :id => bob_s_note.id
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_delete_destroy
    assert_difference "Note.count", -1 do
      delete :destroy, :id => @note.id
    end
    assert_response :redirect
    assert_redirected_to node_url(@note.node)
    assert_equal \
      "Successfully destroyed leaf. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
  end

  # methods

  def test_undo_link
    controller = NotesController.new
    controller.stubs(:revert_version_path).returns("/versions/1/l/revert")
    controller.instance_variable_set(:@note, @note)
    expected = <<-LINK.gsub(/^\s{6}|\n/, "")
      <a data-method="post" href="/versions/1/l/revert" rel="nofollow">undo</a>
    LINK
    assert_equal expected, controller.send(:undo_link)
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
  end

  def logout
    logout_user
  end
end
