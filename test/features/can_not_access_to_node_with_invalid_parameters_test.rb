require "test_helper"

class CanNotAccessToNodeWithInvalidParametersTest < Capybara::Rails::TestCase
  include AuthenticationHelper

  fixtures(:nodes)

  setup(:login, :build_node_tree)
  teardown(:logout)

  # showing

  def test_404_not_found_error_at_showing_with_invalid_id
    visit("/b/0")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  def test_404_not_found_error_at_showing_with_others_node_id
    tim_s_node = nodes(:lib)
    visit("/b/#{tim_s_node.id}")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  # creation

  def test_404_not_found_error_at_creation_with_invalid_parent_id
    visit("/b/0/b/new")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  def test_404_not_found_error_at_creation_with_others_parent_id
    tim_s_node = nodes(:lib)

    visit("/b/#{tim_s_node.id}/b/new")
    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  # edting

  def test_404_not_found_error_at_editing_with_invalid_id
    visit("/b/0/edit")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  def test_404_not_found_error_at_editing_with_others_node_id
    tim_s_node = nodes(:lib)
    visit("/b/#{tim_s_node.id}/edit")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  # deleting

  def test_404_not_found_error_at_deleting_with_invalid_id
    visit("/b/0/delete")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  def test_404_not_found_error_at_deleting_with_others_node_id
    tim_s_node = nodes(:lib)
    visit("/b/#{tim_s_node.id}/delete")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  private

    def login
      login_as_bob
    end

    def build_node_tree
      Node.rebuild!
    end

    def logout
      logout!
    end
end
