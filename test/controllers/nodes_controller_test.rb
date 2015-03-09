require "test_helper"

class NodesControllerTest < ActionController::TestCase
  fixtures(:nodes, :notes, :users)

  setup(:login, :build_node_tree)
  teardown(:logout)

  # actions

  def test_get_index_without_nest
    node = nodes(:weenie_s_home)
    get(:index)

    assert_equal(node, assigns(:node))
    assert_template(:index)
    assert_response(:success)
  end

  def test_get_show_with_others_node
    oswald_s_node = nodes(:oswald_s_home)

    assert_raise(ActiveRecord::RecordNotFound) do
      get(:show, :id => oswald_s_node.id)
    end

    refute(assigns(:node))
  end

  def test_get_show
    node = nodes(:works)
    get(:show, :id => node.id)

    assert_equal(node, assigns(:node))
    assert_template(:show)
    assert_response(:success)
  end

  def test_get_show_js_via_xhr
    node = nodes(:works)
    xhr(:get, :show, :id => node.id, :format => :js)

    assert_equal(node, assigns(:node))
    assert_template(:show)
    assert_response(:success)
  end

  def test_get_show_text
    node = nodes(:works)
    xhr(:get, :show, :id => node.id, :format => :text)

    assert_equal(node, assigns(:node))
    assert_template(:show)
    assert_response(:success)
  end

  def test_get_new_with_others_parent_node
    oswald_s_node = nodes(:oswald_s_home)

    assert_raise(ActiveRecord::RecordNotFound) do
      get(:new, :node_id => oswald_s_node.id)
    end

    refute(assigns(:parent))
    refute(assigns(:node))
  end

  def test_get_new
    node = nodes(:weenie_s_home)
    get(:new, :node_id => node.id)

    assert_kind_of(Node, assigns(:node))
    assert_equal(node, assigns(:parent))
    assert_template(:new)
    assert_template(:partial => "_form")
    assert_response(:success)
  end

  def test_post_create_with_others_parent_node
    oswald_s_node = nodes(:oswald_s_home).children.first
    params = {
      :node_id => oswald_s_node.id,
      :node    => {
        :name => "Not allowed, right?"
      }
    }

    assert_no_difference("Node.count", 1) do
      assert_raise(ActiveRecord::RecordNotFound) do
        post(:create, params)
      end
    end

    refute(assigns(:parent))
    refute(assigns(:node))
  end

  def test_post_create_with_validation_errors
    node = nodes(:weenie_s_home)
    params = {
      :node_id => node.id,
      :node    => {
        :name => ""
      }
    }

    assert_no_difference("Node.count", 1) do
      post(:create, params)
    end

    assert_instance_of(Node, assigns(:node))
    refute(assigns(:node).persisted?)
    assert_equal(node, assigns(:parent))
    assert_nil(flash[:notice])
    assert_template(:new)
    assert_template(:partial => "shared/_errors")
    assert_template(:partial => "_form")
    assert_response(:success)
  end

  def test_post_create
    node = nodes(:weenie_s_home)
    params = {
      :node_id => node.id,
      :node    => {
        :name => "New child node"
      }
    }

    assert_difference("Node.count", 1) do
      post(:create, params)
    end

    assert_instance_of(Node, assigns(:node))
    assert(assigns(:node).persisted?)
    assert_equal(node, assigns(:parent))
    assert_equal(
      "Successfully created branch. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
    )
    assert_response(:redirect)
    assert_redirected_to(node_url(node))
  end

  def test_get_edit_with_root_node
    node = nodes(:weenie_s_home)
    get(:edit, :id => node.id)

    assert_equal(node, assigns(:node))
    assert_response(:redirect)
    assert_redirected_to(nodes_url)
  end

  def test_get_edit_with_others_node
    oswald_s_node = nodes(:oswald_s_home)

    assert_raise(ActiveRecord::RecordNotFound) do
      get(:edit, :id => oswald_s_node.id)
    end

    refute(assigns(:node))
  end

  def test_get_edit
    node = nodes(:works)
    get(:edit, :id => node.id)

    assert_equal(node, assigns(:node))
    assert_template(:edit)
    assert_template(:partial => "_form")
    assert_response(:success)
  end

  def test_put_update_with_root_node
    node = nodes(:weenie_s_home)
    params = {
      :id   => node.id,
      :node => {
        :name => "Not allwoed, right?"
      }
    }
    put(:update, params)

    assert_equal(node, assigns(:node))
    assert_nil(flash[:notice])
    assert_response(:redirect)
    assert_redirected_to(nodes_url)
  end

  def test_put_update_with_others_parent_node
    oswald_s_node = nodes(:oswald_s_home).children.first
    params = {
      :id   => oswald_s_node.id,
      :node => {
        :name => "Not allowed, right?"
      }
    }

    assert_raise(ActiveRecord::RecordNotFound) do
      put(:update, params)
    end

    assert_nil(flash[:notice])
    refute(assigns(:node))
  end

  def test_put_update_with_validation_errors
    node = nodes(:works)
    params = {
      :id   => node.id,
      :node => {
        :name => ""
      }
    }
    put(:update, params)

    assert_equal(node, assigns(:node))
    assert_nil(flash[:notice])
    assert_template(:edit)
    assert_template(:partial => "shared/_errors")
    assert_template(:partial => "_form")
    assert_response(:success)
  end

  def test_put_update
    node = nodes(:works)
    params = {
      :id   => node.id,
      :node => {
        :name => "Study"
      }
    }
    put(:update, params)

    assert_equal(params[:node][:name], assigns(:node).name)
    assert_equal(
      "Successfully updated branch. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
    )
    assert_response(:redirect)
    assert_redirected_to assigns(:node)
  end

  def test_get_delete_with_root_node
    node = nodes(:weenie_s_home)
    get(:delete, :id => node.id)

    assert_equal(node, assigns(:node))
    assert_response(:redirect)
    assert_redirected_to(nodes_url)
  end

  def test_get_delete_with_others_node
    oswald_s_node = nodes(:oswald_s_home)

    assert_raise(ActiveRecord::RecordNotFound) do
      get(:delete, :id => oswald_s_node.id)
    end

    refute(assigns(:node))
  end

  def test_get_delete
    node = nodes(:works)
    get(:delete, :id => node.id)

    assert_equal(node, assigns(:node))
    assert_template(:delete)
    assert_response(:success)
  end

  def test_delete_destroy_with_root_node
    node = nodes(:weenie_s_home)
    assert_no_difference("Node.count", -1) do
      delete(:destroy, :id => node.id)
    end

    assert_equal(node, assigns(:node))
    assert_nil(flash[:notice])
    assert_response(:redirect)
    assert_redirected_to(nodes_url)
  end

  def test_delete_destroy_with_non_blank_node
    node = nodes(:issues)

    assert_no_difference("Node.count", -1) do
      delete(:destroy, :id => node.id)
    end

    assert_equal(node, assigns(:node))
    assert_nil(flash[:notice])
    assert_response(:redirect)
    assert_redirected_to(edit_node_url(node))
  end

  def test_delete_destroy_with_others_node
    oswald_s_node = nodes(:oswald_s_home).children.first

    assert_no_difference("Node.count", -1) do
      assert_raise(ActiveRecord::RecordNotFound) do
        delete(:destroy, :id => oswald_s_node.id)
      end
    end

    assert_nil(flash[:notice])
    refute(assigns(:node))
  end

  def test_delete_destroy
    node = nodes(:works)

    assert_difference("Node.count", -1) do
      delete(:destroy, :id => node.id)
    end

    assert_equal(node, assigns(:node))
    refute(assigns(:node).persisted?)
    assert_equal(
      "Successfully destroyed branch. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
    )
    assert_response(:redirect)
    assert_redirected_to(nodes_url)
  end

  # methods

  def test_load_node
    controller = NodesController.new
    controller.request = request
    node = nodes(:weenie_s_home)
    controller.params[:id] = node.id
    controller.send(:load_node)

    assert_equal(node, controller.instance_variable_get(:@node))
  end

  def test_load_parent
    controller = NodesController.new
    controller.request = request
    node = nodes(:weenie_s_home)
    controller.params[:node_id] = node.id
    controller.send(:load_parent)

    assert_equal(node, controller.instance_variable_get(:@parent))
  end

  def test_block_root_with_root_node
    controller = NodesController.new
    controller.request = request
    node = nodes(:weenie_s_home)
    controller.instance_variable_set(:@node, node)
    response = ActionDispatch::Response.new
    controller.instance_variable_set(:@_response, response)
    controller.send(:block_root)

    assert_equal(302, controller.status)
    assert_equal(nodes_url, response.redirect_url)
  end


  def test_block_non_blank_node_with_non_blank_node
    controller = NodesController.new
    controller.request = request
    node = nodes(:issues)
    controller.instance_variable_set(:@node, node)
    response = ActionDispatch::Response.new
    controller.instance_variable_set(:@_response, response)
    controller.send(:block_non_blank_node)

    assert_equal(302, controller.status)
    assert_equal(edit_node_url(node), response.redirect_url)
  end

  def test_block_non_blank_node_with_blank_node
    controller = NodesController.new
    controller.request = request
    node = nodes(:works)
    controller.instance_variable_set(:@node, node)
    response = ActionDispatch::Response.new
    controller.instance_variable_set(:@_response, response)
    controller.send(:block_non_blank_node)

    assert_equal(200, controller.status)
    assert_nil(response.redirect_url)
  end

  def test_undo_link
    controller = NodesController.new
    controller.request = request
    node = nodes(:works)
    node.update_attribute(:name, "Public")
    prev_version = node.versions.last
    controller.instance_variable_set(:@node, node)
    expected = <<-LINK.gsub(/^\s{6}|\n/, "")
      <a data-method="post"
       href="/v/#{prev_version.id}/b/revert" rel="nofollow">undo</a>
    LINK

    assert_equal(expected, controller.send(:undo_link))
  end

  private

    def login
      user = users(:weenie)
      login_user(user)
    end

    def build_node_tree
      Node.rebuild!
    end

    def logout
      logout_user
    end
end
