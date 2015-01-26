require "test_helper"

class CanAccessToNoteTest < Capybara::Rails::TestCase
  include AuthenticationHelper

  fixtures :nodes, :notes

  setup :login, :initialize_node, :initialize_note
  teardown :logout

  # showing

  def test_successfully_showing_with_valid_id
    visit "/l/#{@note.id}"
    assert page.status_code, 200
    assert_content page, "SHOW"
    assert_content page, @note.name
  end

  # creation

  def test_successfully_creation_with_valid_id
    visit "/b/#{@note.node_id}/l/new"
    assert page.status_code, 200
    assert_content page, "NEW 'LEAF"

    within("//form[@id=new_note]") do
      fill_in "canvas", :with => <<-CONTENT.gsub(/^\s{8}/, "")
        * foo
          * bar
          * baz
      CONTENT
      click_button "Save"
    end
    assert page.status_code, 200
    assert_content page, "Successfully created leaf"
  end

  # updating

  def test_successfully_updating_with_valid_id
    visit "/l/#{@note.id}/edit"
    assert page.status_code, 200

    within("//form[@id=edit_note_#{@note.id}]") do
      fill_in "canvas", :with => <<-CONTENT.gsub(/^\s{8}/, "")
        * qux
          * quux
          * boom
      CONTENT
      click_button "Save"
    end
    assert page.status_code, 200
    assert_content page, "Successfully updated leaf"
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
