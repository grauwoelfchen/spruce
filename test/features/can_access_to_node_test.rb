require "test_helper"

class CanAccessToNodeTest < Capybara::Rails::TestCase
  include AuthenticationHelper

  fixtures(:nodes, :notes)

  setup(:login, :build_node_tree)
  teardown(:logout)

  # showing

  def test_successfully_showing_html_with_valid_id
    node = nodes(:lib)
    visit("/b/#{node.id}")

    assert_equal(200, page.status_code)
    assert_equal("text/html; charset=utf-8",
      page.response_headers["Content-Type"])
    assert_match(/html/, page.body)
    assert_content("SHOW")
    assert_content(node.name)
  end

  def test_successfully_showing_text_with_valid_id
    node = nodes(:var)
    visit("/b/#{node.id}.txt")

    assert_equal(200, page.status_code)
    assert_equal("text/plain; charset=utf-8",
      page.response_headers["Content-Type"])
    refute_match(/html/, page.body)
    assert_content(node.children.first.name)
  end

  # creation

  def test_successfully_creation_with_valid_id
    node = nodes(:lib)
    visit("/b/#{node.id}/b/new")

    assert_equal(200, page.status_code)
    assert_content("NEW 'BRANCH")

    within("//form[@id=new_node]") do
      fill_in("node_name", :with => "log")
      click_button("Save")
    end

    assert_equal(200, page.status_code)
    assert_content("Successfully created branch")
  end

  # updating

  def test_successfully_updating_with_valid_id
    node = nodes(:lib)
    visit("/b/#{node.id}/edit")

    assert_equal(200, page.status_code)

    within("//form[@id=edit_node_#{node.id}]") do
      fill_in("node_name", :with => "www")
      click_button("Save")
    end

    assert_equal(200, page.status_code)
    assert_content("Successfully updated branch")
  end

  # destroying

  def test_successfully_destroying_with_with_js
    node = nodes(:lib)
    visit("/b/#{node.id}/edit")

    assert_equal(200, page.status_code)

    within("//div[@class=destroy]") do
      click_link("Delete")
    end

    assert_equal(200, page.status_code)
    assert_equal("http://example.org/b", page.current_url)
    assert_content("Successfully destroyed branch")

    visit("/b/#{node.id}")

    assert_equal(404, page.status_code)
  end

  def test_does_not_show_destroy_button_in_edit_if_node_has_child_node
    node = nodes(:var)
    visit("/b/#{node.id}/edit")

    assert_equal("http://example.org/b/#{node.id}/edit", page.current_url)
    assert_equal(200, page.status_code)
    refute_match(/Destroy/, page.body)
  end

  def test_redirect_back_to_edit_if_node_has_child_node
    node = nodes(:var)
    visit("/b/#{node.id}/delete")

    assert_equal("http://example.org/b/#{node.id}/edit", page.current_url)
    assert_equal(200, page.status_code)
    refute_match(/Destroy/, page.body)
  end

  def test_redirect_back_to_edit_if_node_has_a_note
    node = nodes(:log)
    visit("/b/#{node.id}/delete")

    assert_equal("http://example.org/b/#{node.id}/edit", page.current_url)
    assert_equal(200, page.status_code)
    refute_match(/Destroy/, page.body)
  end

  def test_successfully_destroying_with_without_js
    node = nodes(:lib)
    visit("/b/#{node.id}/delete")

    assert_equal(200, page.status_code)

    within("//form") do
      click_button("Destroy")
    end

    assert_equal(200, page.status_code)
    assert_equal("http://example.org/b", page.current_url)
    assert_content("Successfully destroyed branch")

    visit("/b/#{node.id}")

    assert_equal(404, page.status_code)
  end

  private

    def login
      login_as_oswald
    end

    def build_node_tree
      Node.rebuild!
    end

    def logout
      logout!
    end
end
