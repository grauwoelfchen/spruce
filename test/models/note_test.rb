require "test_helper"

class NoteTest < ActiveSupport::TestCase
  fixtures :notes

  # validation

  def test_save_without_content
    note = Note.new
    assert !note.save, "Saved the note without content"
  end

  def test_update_without_content
    note = notes(:linux_book)
    assert !note.update_attributes(:content => ""), "Updated the note without content"
  end
end
