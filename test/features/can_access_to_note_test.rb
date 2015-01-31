require "test_helper"

class CanAccessToNoteTest < Capybara::Rails::TestCase
  include AuthenticationHelper

  fixtures :nodes, :notes

  setup :login, :initialize_node, :initialize_note
  teardown :logout

  # showing

  def test_successfully_showing_html_with_valid_id
    visit "/l/#{@note.id}"
    assert_equal 200, page.status_code
    assert_equal "text/html; charset=utf-8",
      page.response_headers["Content-Type"]
    assert_match /html/, page.body
    assert_content "SHOW"
    assert_content @note.name
  end

  def test_successfully_showing_text_with_valid_id
    visit "/l/#{@note.id}.txt"
    assert_equal 200, page.status_code
    assert_equal "text/plain; charset=utf-8",
      page.response_headers["Content-Type"]
    refute_match /html/, page.body
    assert_content @note.name
  end

  # creation

  def test_successfully_creation_with_valid_id
    visit "/b/#{@note.node_id}/l/new"
    assert_equal 200, page.status_code
    assert_content "NEW 'LEAF"

    within("//form[@id=new_note]") do
      fill_in "canvas", :with => <<-CONTENT.gsub(/^\s{8}/, "")
        * foo
          * bar
          * baz
      CONTENT
      click_button "Save"
    end
    assert_equal 200, page.status_code
    assert_content "Successfully created leaf"
  end

  # updating

  def test_successfully_updating_with_valid_id
    visit "/l/#{@note.id}/edit"
    assert_equal 200, page.status_code

    within("//form[@id=edit_note_#{@note.id}]") do
      fill_in "canvas", :with => <<-CONTENT.gsub(/^\s{8}/, "")
        * qux
          * quux
          * boom
      CONTENT
      click_button "Save"
    end
    assert_equal 200, page.status_code
    assert_content "Successfully updated leaf"
  end

  private

    def login
      login_as_tim
    end

    def initialize_node
      Node.rebuild!
    end

    def initialize_note
      @note = notes(:linux_book)
    end

    def logout
      logout!
    end
end
