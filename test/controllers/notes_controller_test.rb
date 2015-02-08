require "test_helper"

class NotesControllerTest < ActionController::TestCase
  fixtures(:notes, :users, :nodes)

  setup(:login, :build_node_tree, :initialize_note)
  teardown(:logout)

  # actions

  def test_get_index_without_nest
    assert_raise(ActionController::UrlGenerationError) do
      get(:index)
    end
  end

  def test_get_index_with_others_node
    bob_s_node = nodes(:bob_s_home)
    assert_raise(ActionController::UrlGenerationError) do
      get(:index, :node_id => bob_s_node.id)
    end
  end

  def test_get_index
    assert_raise(ActionController::UrlGenerationError) do
      get(:index, :node_id => @note.node.id)
    end
  end

  def test_get_show_with_others_note
    bob_s_note = notes(:idea_note)
    assert_raise(ActiveRecord::RecordNotFound) do
      get(:show, :id => bob_s_note.id)
    end
    refute(assigns(:note))
    refute(assigns(:node))
  end

  def test_get_show
    get(:show, :id => @note.id)
    assert_equal(@note, assigns(:note))
    assert_equal(@note.node, assigns(:node))
    assert_template(:show)
    assert_response(:success)
  end

  def test_get_new_without_nest
    assert_raise(ActionController::UrlGenerationError) do
      get(:new)
    end
  end

  def test_get_new_with_others_node
    bob_s_node = nodes(:bob_s_home)
    assert_raise ActiveRecord::RecordNotFound do
      get :new, :node_id => bob_s_node.id
    end
    refute(assigns(:node))
  end

  def test_get_new
    get(:new, :node_id => @note.node.id)
    assert_instance_of(Note, assigns(:note))
    assert_equal(@note.node, assigns(:node))
    assert_template(:new)
    assert_template(:partial => "_form")
    assert_response(:success)
  end

  def test_post_create_without_nest
    assert_raise(ActionController::UrlGenerationError) do
      post(:create, :note => {:content => "* Unknown Note\r\n* Unexpected"})
    end
  end

  def test_post_create_with_others_node
    bob_s_node = nodes(:bob_s_home)
    params = {
      :node_id => bob_s_node.id,
      :note    => {
        :content => "Not allowed, right?\r\n"
      }
    }
    assert_no_difference("Node.count", 1) do
      assert_raise(ActiveRecord::RecordNotFound) do
        post(:create, params)
      end
    end
    refute(assigns(:node))
    refute(assigns(:note))
  end

  def test_post_create_with_validation_errors
    params = {
      :node_id => @note.node.id,
      :note    => {
        :content => ""
      }
    }
    assert_no_difference("Note.count", 1) do
      post(:create, params)
    end
    assert_instance_of(Note, assigns(:note))
    refute(assigns(:note).persisted?)
    assert_equal(@note.node, assigns(:node))
    assert_nil(flash[:notice])
    assert_template(:new)
    assert_template(:partial => "shared/_errors")
    assert_template(:partial => "_form")
    assert_response(:success)
  end

  def test_post_create
    params = {
      :node_id => @note.node.id,
      :note    => {
        :content => "* More Hard Linux beginner's Book\r\n"
      }
    }
    assert_difference("Note.count", 1) do
      post(:create, params)
    end
    assert_instance_of(Note, assigns(:note))
    assert(assigns(:note).persisted?)
    assert_equal(@note.node, assigns(:node))
    assert_equal(
      "Successfully created leaf. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
    )
    assert_response(:redirect)
    assert_redirected_to(note_url(assigns(:note)))
  end

  def test_get_edit_with_others_note
    bob_s_note = notes(:idea_note)
    assert_raise(ActiveRecord::RecordNotFound) do
      get(:edit, :id => bob_s_note.id)
    end
    refute(assigns(:note))
    refute(assigns(:node))
  end

  def test_get_edit
    get(:edit, :id => @note.id)
    assert_equal(@note, assigns(:note))
    assert_equal(@note.node, assigns(:node))
    assert_template(:edit)
    assert_template(:partial => "_form")
    assert_response(:success)
  end

  def test_put_update_with_others_note
    bob_s_note = notes(:idea_note)
    params = {
      :id   => bob_s_note.id,
      :note => {
        :content => "Not allowed, right?"
      }
    }
    assert_raise(ActiveRecord::RecordNotFound) do
      put(:update, params)
    end
    refute(flash[:notice])
    refute(assigns(:note))
    refute(assigns(:node))
  end

  def test_put_update_with_validation_errors
    put(:update, :id => @note.id, :note => {:content => ""})
    assert_response(:success)
    assert_equal(@note, assigns(:note))
    assert_equal(@note.node, assigns(:node))
    refute(flash[:notice])
    assert_template(:edit)
    assert_template(:partial => "shared/_errors")
    assert_template(:partial => "_form")
  end

  def test_put_update
    params = {
      :id   => @note.id,
      :note => {
        :content =>
          "* Little Hard Linux user's Book\r\n* Getting Started"
      }
    }
    put(:update, params)
    assert_equal(params[:note][:content], assigns(:note).content)
    assert_equal(@note.node, assigns(:node))
    assert_equal(
      "Successfully updated leaf. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
    )
    assert_response(:redirect)
    assert_redirected_to(note_url(assigns(:note)))
  end

  def test_get_delete_with_others_note
    bob_s_note = notes(:idea_note)
    assert_raise(ActiveRecord::RecordNotFound) do
      get(:delete, :id => bob_s_note.id)
    end
    refute(assigns(:note))
    refute(assigns(:node))
  end

  def test_get_delete
    get(:delete, :id => @note.id)
    assert_equal(@note, assigns(:note))
    assert_equal(@note.node, assigns(:node))
    assert_template(:delete)
    assert_response(:success)
  end

  def test_delete_destroy_with_others_note
    bob_s_note = notes(:idea_note)
    assert_no_difference("Note.count", -1) do
      assert_raise (ActiveRecord::RecordNotFound) do
        delete(:destroy, :id => bob_s_note.id)
      end
    end
    refute(assigns(:note))
    refute(assigns(:node))
  end

  def test_delete_destroy
    assert_difference("Note.count", -1) do
      delete(:destroy, :id => @note.id)
    end
    assert_equal(@note, assigns(:note))
    refute(assigns(:note).persisted?)
    assert_equal(
      "Successfully destroyed leaf. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
    )
    assert_response(:redirect)
    assert_redirected_to(node_url(@note.node))
  end

  # methods

  def test_load_note
    controller = NotesController.new
    controller.request = request
    controller.params[:id] = @note.id

    controller.send(:load_note)
    assert_equal(@note, controller.instance_variable_get(:@note))
  end

  def test_undo_link
    controller = NotesController.new
    controller.request = request
    @note.update_attribute(:name, "Updated hard Linux Book")
    prev_version = @note.versions.last
    controller.instance_variable_set(:@note, @note)

    expected = <<-LINK.gsub(/^\s{6}|\n/, "")
      <a data-method="post"
       href="/v/#{prev_version.id}/l/revert" rel="nofollow">undo</a>
    LINK
    assert_equal(expected, controller.send(:undo_link))
  end

  private

    def login
      user = users(:tim)
      login_user(user)
    end

    def build_node_tree
      Node.rebuild!
    end

    def initialize_note
      @note = notes(:linux_book)
    end

    def logout
      logout_user
    end
end
