require "test_helper"

class NodesControllerTest < ActionController::TestCase
  fixtures :nodes, :users

  setup    :login, :initialize_node
  teardown :logout

  # actions

  def test_get_index_without_nest
    get :index
    assert_response :success
    assert_equal @node, assigns(:node)
    assert_template :index
  end

  def test_get_index_with_others_node
    node = nodes(:tim_s_home)
    get :index, :node_id => node.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_index_with_nest
    get :index, :node_id => @node.id
    assert_response :success
    assert_equal @node, assigns(:node)
    assert_template :index
  end

  def test_get_show_with_others_node
    node = nodes(:tim_s_home)
    get :show, :id => node.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_show
    get :show, :id => @node.id
    assert_response :success
    assert_equal @node, assigns(:node)
    assert_template :show
  end

  def test_get_new_with_others_node
    node = nodes(:tim_s_home)
    get :new, :node_id => node.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_new
    get :new, :node_id => @node.id
    assert_response :success
    assert_kind_of Node, assigns(:node)
    assert_not_nil assigns(:node).parent
    assert_template :new
    assert_template :partial => "_form"
  end

  def test_post_create_with_others_node
    node = nodes(:tim_s_home).children.first
    assert_no_difference("Node.count", 1) do
      post :create, :node_id => node.id, :node => { :name => "Not allowed, right?" }
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_post_create_with_validation_errors
    assert_no_difference("Node.count", 1) do
      post :create, :node_id => @node.id, :node => { :name => "" }
    end
    assert_response :success
    assert_instance_of Node, assigns(:node)
    assert_template :new
    assert_template :partial => "shared/_errors"
    assert_template :partial => "_form"
  end

  def test_post_create
    assert_difference("Node.count", 1) do
      post :create, :node_id => @node.id, :node => { :name => "New child node" }
    end
    assert_response :redirect
    assert_redirected_to node_nodes_url(@node)
  end

  def test_get_edit_with_root_node # not allowed
    get :edit, :id => @node.id
    assert_response :redirect
    assert_redirected_to node_nodes_url(@node)
  end

  def test_get_edit_with_others_node
    node = nodes(:tim_s_home)
    get :edit, :id => node.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_edit
    node = @node.children.first
    get :edit, :id => node.id
    assert_response :success
    assert_equal node, assigns(:node)
    assert_template :edit
    assert_template :partial => "_form"
  end

  def test_put_update_with_others_node
    node = nodes(:tim_s_home).children.first
    put :update, :id => node.id, :node => { :name => "Not allowed, right?" }
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_put_update_with_validation_errors
    node = @node.children.first
    put :update, :id => node.id, :node => { :name => "" }
    assert_response :success
    assert_equal node, assigns(:node)
    assert_template :edit
    assert_template :partial => "shared/_errors"
    assert_template :partial => "_form"
  end

  def test_put_update
    node = @node.children.first
    put :update, :id => node.id, :node => { :name => "Study" }
    assert_response :redirect
    assert_redirected_to assigns(:node)
  end

  def test_delete_destroy_with_others_node
    node = nodes(:tim_s_home).children.first
    assert_no_difference("Node.count", -1) do
      delete :destroy, :id => node.id
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_delete_destroy
    node = @node.children.first
    assert_difference("Node.count", -1) do
      delete :destroy, :id => node.id
    end
    assert_response :redirect
    assert_redirected_to nodes_url
  end

  private

  def login
    user = users(:bob)
    login_user(user)
  end

  def initialize_node
    Node.rebuild!
    @node = nodes(:bob_s_home)
  end

  def logout
    logout_user
  end
end
