require "test_helper"

class NoteTest < ActiveSupport::TestCase
  fixtures :notes

  # validation

  test "saving without content" do
    note = Note.new
    assert !note.save, "Saved the note without content"
  end

  test "updating without content" do
    note = notes("linux-book")
    assert !note.update_attributes(:content => ""), "Updated the note without content"
  end
end
