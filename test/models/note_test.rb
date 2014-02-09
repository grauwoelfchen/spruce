require "test_helper"

class NoteTest < ActiveSupport::TestCase
  fixtures :notes, :users

  # properties

  def test_properties
    note = Note.new
    assert_respond_to note, :name
    assert_respond_to note, :content
  end

  # validations

  def test_validation_without_user_id
    note = Note.new(:user_id => nil)
    note.valid?
    assert_equal 1, note.errors[:user_id].length
    assert_equal "can't be blank", note.errors[:user_id].first
  end

  def test_validation_with_blank_name
    note = Note.new(:name => "", :content => "\r\n\r\ntest")
    note.valid?
    assert_equal 1, note.errors[:name].length
    assert_equal "can't be blank", note.errors[:name].first
  end

  def test_validation_with_blank_content
    note = Note.new(:content => "")
    note.valid?
    assert_equal 1, note.errors[:content].length
    assert_equal "can't be blank", note.errors[:content].first
  end

  # save & update

  def test_save_with_errors
    note = Note.new
    assert_not note.save, "Saved the note with errors"
  end

  def test_save_without_errors
    attributes = {
      :content => "Test\r\nThis is test"
    }
    user = users(:tim)
    note = Note.new(attributes).assign_to(user)
    assert note.save, "Failed to save the note without errors"
  end

  def test_update_with_errors
    note = notes(:linux_book)
    assert_not note.update_attributes(:content => ""), "Updated the note with errors"
  end

  def test_update_without_errors
    attributes = {
      :content => <<-NOTE
# "New" Little hard Linux beginner's Book
...
      NOTE
    }
    note = notes(:linux_book)
    assert note.update_attributes(attributes), "Failed to update the note without errors"
  end

  # included methods

  def test_responding_to_visible_to
    assert_respond_to Note, :visible_to
  end

  def test_responding_to_assign_to
    note = Note.new
    assert_respond_to note, :assign_to
  end

  def test_visible_to
    user = users(:bob)
    assert_kind_of ActiveRecord::Relation, Note.visible_to(user)
  end

  def test_assign_to
    note = Note.new
    user = users(:bob)
    result = note.assign_to(user)
    assert_kind_of Note, result
    assert_equal user.id, result.user_id
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
