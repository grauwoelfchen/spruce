require "test_helper"

class CanAccessToNodeTest < Capybara::Rails::TestCase
  include AuthenticationHelper

  fixtures :nodes

  setup :login, :initialize_node
  teardown :logout

  # showing

  def test_successfully_showing_with_valid_id
    visit "/b/#{@node.id}"
    assert page.status_code, 200
    assert_content page, "SHOW"
    assert_content page, @node.name
  end

  # creation

  def test_successfully_creation_with_valid_id
    visit "/b/#{@node.id}/b/new"
    assert page.status_code, 200
    assert_content page, "NEW 'BRANCH"

    within("//form[@id=new_node]") do
      fill_in "node_name", :with => "log"
      click_button "Save"
    end
    assert page.status_code, 200
    assert_content page, "Successfully created branch"
  end

  # updating

  def test_successfully_updating_with_valid_id
    visit "/b/#{@node.id}/edit"
    assert page.status_code, 200

    within("//form[@id=edit_node_#{@node.id}]") do
      fill_in "node_name", :with => "www"
      click_button "Save"
    end
    assert page.status_code, 200
    assert_content page, "Successfully updated branch"
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
