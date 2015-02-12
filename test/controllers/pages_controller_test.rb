require "test_helper"

class PagesControllerTest < ActionController::TestCase
  fixtures(:nodes, :users)

  def test_get_index_without_logged_in_user
    get(:index)

    assert_template(:index)
    assert_response(:success)
  end

  def test_get_index_with_logged_in_user
    login
    build_node_tree
    node = nodes(:bob_s_home)
    get(:index)

    assert_equal(node, assigns(:root))
    assert_template(:index)
    assert_response(:success)

    logout
  end

  def test_get_introduction
    get(:introduction)

    assert_template(:introduction)
    assert_response(:success)
  end

  def test_get_changelog
    get(:changelog)

    assert_template(:changelog)
    assert_response(:success)
  end

  private

    def login
      user = users(:bob)
      login_user(user)
    end

    def build_node_tree
      Node.rebuild!
    end

    def logout
      logout_user
    end
end
