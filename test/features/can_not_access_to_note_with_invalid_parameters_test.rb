require "test_helper"

class CanNotAccessToNoteWithInvalidParametersTest < Capybara::Rails::TestCase
  include AuthenticationHelper

  fixtures(:nodes, :notes)

  setup(:login, :initialize_node)
  teardown(:logout)

  # showing

  def test_404_not_found_error_at_showing_with_invalid_id
    visit("/l/0")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  def test_404_not_found_error_at_showing_with_others_note_id
    tim_s_note = notes(:wish_list)
    visit("/l/#{tim_s_note.id}")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  # creation

  def test_404_not_found_error_at_creation_with_invalid_parent_id
    visit("/b/0/l/new")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  def test_404_not_found_error_at_creation_with_others_parent_id
    tim_s_node = nodes(:lib)
    visit("/b/#{tim_s_node.id}/l/new")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  # edting

  def test_404_not_found_error_at_creation_with_invalid_id
    visit("/l/0/edit")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  def test_404_not_found_error_at_editing_with_others_note_id
    tim_s_note = notes(:wish_list)
    visit("/l/#{tim_s_note.id}/edit")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  # deleting

  def test_404_not_found_error_at_deleting_with_invalid_id
    visit("/l/0/delete")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  def test_404_not_found_error_at_deleting_with_others_note_id
    tim_s_note = notes(:wish_list)
    visit("/l/#{tim_s_note.id}/delete")

    assert_equal(404, page.status_code)
    assert_content("Not Found :-p")
  end

  private

    def login
      login_as_bob
    end

    def initialize_node
      Node.rebuild!
    end

    def logout
      logout!
    end
end
