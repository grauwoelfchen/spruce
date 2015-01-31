require "test_helper"

class CanAccessToNodeTest < Capybara::Rails::TestCase
  include AuthenticationHelper

  fixtures :nodes

  setup :login, :initialize_node
  teardown :logout

  # showing

  def test_successfully_showing_html_with_valid_id
    visit "/b/#{@node.id}"
    assert_equal 200, page.status_code
    assert_equal "text/html; charset=utf-8",
      page.response_headers["Content-Type"]
    assert_match /html/, page.body
    assert_content "SHOW"
    assert_content @node.name
  end

  def test_successfully_showing_text_with_valid_id
    visit "/b/#{@node.id}.txt"
    assert_equal 200, page.status_code
    assert_equal "text/plain; charset=utf-8",
      page.response_headers["Content-Type"]
    refute_match /html/, page.body
    assert_content @node.children.first.name
  end

  # creation

  def test_successfully_creation_with_valid_id
    visit "/b/#{@node.id}/b/new"
    assert_equal 200, page.status_code
    assert_content "NEW 'BRANCH"

    within("//form[@id=new_node]") do
      fill_in "node_name", :with => "log"
      click_button "Save"
    end
    assert_equal 200, page.status_code
    assert_content "Successfully created branch"
  end

  # updating

  def test_successfully_updating_with_valid_id
    visit "/b/#{@node.id}/edit"
    assert_equal 200, page.status_code

    within("//form[@id=edit_node_#{@node.id}]") do
      fill_in "node_name", :with => "www"
      click_button "Save"
    end
    assert_equal 200, page.status_code
    assert_content "Successfully updated branch"
  end

  private

    def login
      login_as_tim
    end

    def initialize_node
      Node.rebuild!
      @node = nodes(:var)
    end

    def logout
      logout!
    end
end
