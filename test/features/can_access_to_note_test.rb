require "test_helper"

class CanAccessToNoteTest < Capybara::Rails::TestCase
  include AuthenticationHelper

  fixtures(:nodes, :notes)

  setup(:login, :build_node_tree)
  teardown(:logout)

  # showing

  def test_successfully_showing_html_with
    note = notes(:linux_book)
    visit("/l/#{note.id}")

    assert_equal(200, page.status_code)
    assert_equal("text/html; charset=utf-8",
      page.response_headers["Content-Type"])
    assert_match(/html/, page.body)
    assert_content("SHOW")
    assert_content(note.name)
  end

  def test_successfully_showing_text_with
    note = notes(:linux_book)
    visit("/l/#{note.id}.txt")

    assert_equal(200, page.status_code)
    assert_equal("text/plain; charset=utf-8",
      page.response_headers["Content-Type"])
    refute_match(/html/, page.body)
    assert_content(note.name)
  end

  # creation

  def test_successfully_creation_with
    note = notes(:linux_book)
    visit("/b/#{note.node_id}/l/new")

    assert_equal(200, page.status_code)
    assert_content("NEW 'LEAF")

    within("//form[@id=new_note]") do
      content = <<-CONTENT.gsub(/^\s{8}/, "")
        * foo
          * bar
          * baz
      CONTENT
      fill_in("canvas", :with => content)
      click_button("Save")
    end

    assert_equal(200, page.status_code)
    assert_content("Successfully created leaf")
  end

  # updating

  def test_successfully_updating_with
    note = notes(:linux_book)
    visit("/l/#{note.id}/edit")

    assert_equal(200, page.status_code)

    within("//form[@id=edit_note_#{note.id}]") do
      content = <<-CONTENT.gsub(/^\s{8}/, "")
        * qux
          * quux
          * boom
      CONTENT
      fill_in("canvas", :with => content)
      click_button("Save")
    end

    assert_equal(200, page.status_code)
    assert_content("Successfully updated leaf")
  end

  # destroying

  def test_successfully_destroying_with_with_js
    note = notes(:linux_book)
    node = note.node
    visit("/l/#{note.id}/edit")

    assert_equal(200, page.status_code)

    within("//div[@class=destroy]") do
      click_link("Delete")
    end

    assert_equal(200, page.status_code)
    assert_equal("http://example.org/b/#{node.id}", page.current_url)
    assert_content("Successfully destroyed leaf")

    visit("/l/#{note.id}")

    assert_equal(404, page.status_code)
  end

  def test_successfully_destroying_with_without_js
    note = notes(:linux_book)
    node = note.node
    visit("/l/#{note.id}/delete")

    assert_equal(200, page.status_code)

    within("//form") do
      click_button("Destroy")
    end

    assert_equal(200, page.status_code)
    assert_equal("http://example.org/b/#{node.id}", page.current_url)
    assert_content("Successfully destroyed leaf")

    visit("/l/#{note.id}")

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
