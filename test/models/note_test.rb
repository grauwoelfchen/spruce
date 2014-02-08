require "test_helper"

class NoteTest < ActiveSupport::TestCase
  fixtures :notes

  # properties

  def test_properties
    note = Note.new
    assert_respond_to(note, :name)
    assert_respond_to(note, :content)
    assert_respond_to(note, :description)
  end

  # validations

  def test_save_with_errors
    note = Note.new
    assert_not note.save, "Saved the note without content"
  end

  def test_update_with_errors
    note = notes(:linux_book)
    assert_not note.update_attributes(:content => ""), "Updated the note without content"
  end

  def test_validation_with_blank_content
    note = Note.new(:content => "")
    note.valid?
    assert_equal 1, note.errors[:content].length
    assert_equal "can't be blank", note.errors[:content].first
  end

  # methods

  def test_name_with_empty_content
    note = notes(:linux_book)
    note.content = ""
    assert_equal nil, note.name
  end

  def test_name_with_nil_content
    note = notes(:linux_book)
    note.content = nil
    assert_equal nil, note.name
  end
end
