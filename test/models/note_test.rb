require "test_helper"

class NoteTest < ActiveSupport::TestCase
  fixtures :notes, :users, :nodes

  # properties

  def test_properties
    note = Note.new
    assert_respond_to note, :name
    assert_respond_to note, :content
  end

  # associations

  def test_associations
    note = Note.new
    assert_respond_to note, :user
    assert_respond_to note, :node
    assert_respond_to note, :recorded_changes
    assert_respond_to note, :versions
  end

  # validations

  def test_validation_without_user_id
    note = Note.new(:user_id => nil)
    assert_not note.valid?
    assert_equal ["can't be blank"], note.errors[:user_id]
  end

  def test_validation_without_node_id
    note = Note.new(:node_id => nil)
    assert_not note.valid?
    assert_equal ["can't be blank"], note.errors[:node_id]
  end

  def test_validation_without_name
    note = Note.new(:content => "\r\n\r\ntest")
    assert_not note.valid?
    assert_equal ["can't be blank"], note.errors[:name]
  end

  def test_validation_with_dot_name
    note = Note.new(:content => ".test\r\n")
    assert_not note.valid?
    assert_equal ["can't start with dot and whitespace"], note.errors[:name]
  end

  def test_validation_with_too_long_name
    note = Note.new(:content => "long" * 100 + "\r\nlong")
    assert_not note.valid?
    assert_equal ["is too long (maximum is 64 characters)"], note.errors[:name]
  end

  def test_validation_with_invalid_name
    note = Note.new(:content => "~test\r\n")
    assert_not note.valid?
    assert_equal ["can't contain %~/\\*`"], note.errors[:name]
  end

  def test_validation_without_content
    note = Note.new(:content => "")
    assert_not note.valid?
    assert_equal ["can't be blank"], note.errors[:content]
  end

  def test_validation_with_invalid_syntax_no_bullet_points
    note = Note.new(:content => "Title\r\n\r\nNo bullet")
    assert_not note.valid?
    expected = {
      :message => "must start with bullet points '* '",
      :lines   => [3],
    }
    assert_equal [expected], note.errors[:content]
  end

  def test_validation_with_invalid_syntax_no_whitespace
    note = Note.new(:content => "Title\r\n\r\n*No whitespace")
    assert_not note.valid?
    expected = {
      :message => "must start with bullet points '* '",
      :lines  => [3],
    }
    assert_equal [expected], note.errors[:content]
  end

  def test_validation_with_invalid_syntax_too_many_whitespace
    note = Note.new(:content => "Title\r\n\r\n*  Too many whitespace")
    assert_not note.valid?
    expected = {
      :message => "must start with bullet points '* '",
      :lines   => [3],
    }
    assert_equal [expected], note.errors[:content]
  end

  def test_validation_with_invalid_syntax_at_multiple_lines
    note = Note.new(:content => "Title\r\n\r\nNo bullet\r\n*No whitespace")
    assert_not note.valid?
    expected = {
      :message => "must start with bullet points '* '",
      :lines   => [3, 4],
    }
    assert_equal [expected], note.errors[:content]
  end

  def test_validation_with_invalid_indent
    # not implemented yet
    skip
    note = Note.new(:content => "Title\r\n\r\n  * Indent")
    assert_not note.valid?
    expected = {
      :message => "has invalid indent",
      :lies    => [3]
    }
    assert_equal [expected], note.errors[:content]
  end

  # actions

  def test_save_with_errors
    note = Note.new
    assert_not note.save
  end

  def test_save_without_errors
    attributes = {
      :content => "Test\r\n* This is test",
      :node    => nodes(:var)
    }
    user = users(:tim)
    note = Note.new(attributes).assign_to(user)
    assert_difference "Version::Cycle.count", 1 do
      assert note.save
    end
    assert_empty note.errors
  end

  def test_update_with_errors
    note = notes(:linux_book)
    assert_not note.update_attributes(:content => "")
  end

  def test_update_without_errors
    attributes = {
      :content => <<-NOTE
New Little hard Linux beginner's Book

* Getting Started
      NOTE
    }
    note = notes(:linux_book)
    assert_difference "Version::Cycle.count", 1 do
      assert note.update_attributes(attributes)
    end
    assert_empty note.errors
  end

  def test_delete
    note = notes(:shopping_list)
    assert note.delete
    assert_nil Note.where(:id => note.id).first
  end

  def test_destroy
    note = notes(:shopping_list)
    assert_difference "Version::Cycle.count", 1 do
      assert note.destroy
    end
    assert_nil Note.where(:id => note.id).first
  end

  # visibility and assignment

  def test_availability_of_visible_to
    assert_respond_to Note, :visible_to
  end

  def test_availability_of_assign_to
    assert_respond_to Note.new, :assign_to
  end

  def test_relation_by_visible_to
    user = users(:bob)
    relation = Note.visible_to(user)
    assert_kind_of ActiveRecord::Relation, relation
    assert_equal ["#{Note.table_name}.user_id = #{user.id}"],
      relation.where_values
  end

  def test_assignment_by_assign_to
    user = users(:bob)
    note = Note.new.assign_to(user)
    assert_kind_of Note, note
    assert_equal user, note.user
  end

  def test_owner_consistency_after_init
    user = users(:bob)
    note = Note.new.assign_to(user)
    assert_equal user.id, note.user_id
    assert_equal user.id, note.user_id_was
  end

  def test_owner_consistency_after_transfer
    new_user = users(:bob)
    original_note = notes(:wish_list)
    note = original_note.assign_to(new_user)
    assert_equal new_user.id, note.user_id
    assert_equal new_user.id, note.user_id_was
  end

  # restoration

  def test_restore_at_undo
    note = notes(:wish_list)
    note.update_attributes(:name => "My Wishlist (private)")
    assert_difference "Version::Cycle.count", 1 do
      assert note.versions.last.restore!
    end
    note.reload
    assert_equal "My Wishlist", note.name
  end

  def test_restore_at_redo
    note = notes(:wish_list)
    note.update_attributes(:content => "My Wishlist (private)\r\n")
    version = note.versions.last
    version.restore!
    assert_difference "Version::Cycle.count", 1 do
      assert version.next.restore!
    end
    note.reload
    assert_equal "My Wishlist (private)", note.name
  end

  # methods

  def test_name_with_blank_content
    note = notes(:linux_book)
    note.content = ""
    assert_nil note.name
  end

  def test_name_with_nil_content
    note = notes(:linux_book)
    note.content = nil
    assert_nil note.name
  end
end
