require "test_helper"

class NodesControllerTest < ActionController::TestCase
  fixtures :nodes, :users

  setup    :login, :initialize_node
  teardown :logout

  # actions

  def test_get_index
    get :index
    assert_response :success
  end

  def test_get_new
    get :new
    assert_response :success
  end

  def test_get_edit
    get :edit, :id => @node.id
    assert_response :success
    assert_equal @node, assigns(:node)
    assert_template :edit
  end

  private

  def login
    user = users(:bob)
    login_user(user)
  end

  def initialize_node
    @node = nodes(:bob_s_home)
    @node.update_attributes(:user => assigns(:current_user))
  end

  def logout
    logout_user
  end
end
