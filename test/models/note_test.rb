require "test_helper"

class NoteTest < ActiveSupport::TestCase
  include CachingHelper

  fixtures(:notes, :users, :nodes)

  # properties

  def test_properties
    note = Note.new

    assert_respond_to(note, :name)
    assert_respond_to(note, :content)
  end

  # associations

  def test_associations
    note = Note.new

    assert_respond_to(note, :user)
    assert_respond_to(note, :node)
    assert_respond_to(note, :recorded_changes)
    assert_respond_to(note, :versions)
  end

  # callbacks

  # FIXME add unittests for callbacks

  def test_operation_application_with_unindent_sign
    attributes = {
      :node    => nodes(:var),
      :content => <<-CONTENT.gsub(/^\s{8}/, "")
        * test
        * foo
          -* bar
      CONTENT
    }
    user = users(:oswald)
    note = Note.new(attributes).assign_to(user)
    note.save
    expected = <<-EXPECTED.gsub(/^\s{6}/, "")
      * test
      * foo
      * bar
    EXPECTED

    assert_empty(note.errors)
    assert_equal(expected, note.content)
  end

  def test_operation_application_with_indent_sign
    attributes = {
      :node    => nodes(:var),
      :content => <<-CONTENT.gsub(/^\s{8}/, "")
        * test
          * foo
          +* bar
      CONTENT
    }
    user = users(:oswald)
    note = Note.new(attributes).assign_to(user)
    note.save
    expected = <<-EXPECTED.gsub(/^\s{6}/, "")
      * test
        * foo
          * bar
    EXPECTED

    assert_empty(note.errors)
    assert_equal(expected, note.content)
  end

  # validations

  def test_validation_without_user_id
    note = Note.new(:user_id => nil)
    refute(note.valid?)

    assert_equal(["can't be blank"], note.errors[:user_id])
  end

  def test_validation_without_node_id
    note = Note.new(:node_id => nil)

    refute(note.valid?)
    assert_equal(["can't be blank"], note.errors[:node_id])
  end

  def test_validation_without_name
    note = Note.new(:content => "\r\ntest")

    refute(note.valid?)
    assert_equal(["can't be blank"], note.errors[:name])
  end

  def test_validation_with_dot_name
    note = Note.new(:content => ".test\r\n")

    refute(note.valid?)
    assert_equal(["can't start with dot and whitespace"], note.errors[:name])
  end

  def test_validation_with_too_long_name
    note = Note.new(:content => "long" * 100 + "\r\nlong")

    refute(note.valid?)
    assert_equal(["is too long (maximum is 64 characters)"],
      note.errors[:name])
  end

  def test_validation_with_invalid_name
    note = Note.new(:content => "~test\r\n")

    refute(note.valid?)
    assert_equal(["can't contain %~/\\*`"], note.errors[:name])
  end

  def test_validation_without_content
    note = Note.new(:content => "")

    refute(note.valid?)
    assert_equal(["can't be blank"], note.errors[:content])
  end

  def test_validation_with_too_long_content
    note = Note.new(:content => "loong" * 2000)

    refute(note.valid?)
    assert_equal(["is too long (maximum is 9216 characters)"],
      note.errors[:content])
  end

  def test_validation_with_blank_line
    note = Note.new(:content => "* First entry\r\n\r\n* Third entry\r\n")
    feedback = {
      :message => "must not contain blank line",
      :lines   => [2],
    }

    refute(note.valid?)
    assert_equal([feedback], note.errors[:content])
  end

  def test_validation_with_invalid_syntax_no_bullet_points
    note = Note.new(:content => "Title\r\nNo bullet")
    feedback = {
      :message => "must start with bullet points '* '",
      :lines   => [1, 2],
    }

    refute(note.valid?)
    assert_equal([feedback], note.errors[:content])
  end

  def test_validation_with_invalid_syntax_no_whitespace
    note = Note.new(:content => "* Title\r\n*No whitespace")
    feedback = {
      :message => "must start with bullet points '* '",
      :lines  => [2],
    }

    refute(note.valid?)
    assert_equal([feedback], note.errors[:content])
  end

  def test_validation_with_invalid_syntax_too_many_whitespace
    note = Note.new(:content => "* Title\r\n*  Too many whitespace")
    feedback = {
      :message => "must start with bullet points '* '",
      :lines   => [2],
    }

    refute(note.valid?)
    assert_equal([feedback], note.errors[:content])
  end

  def test_validation_with_invalid_syntax_at_multiple_lines
    note = Note.new(:content => "* Title\r\nNo bullet\r\n*No whitespace")
    feedback = {
      :message => "must start with bullet points '* '",
      :lines   => [2, 3],
    }

    refute(note.valid?)
    assert_equal([feedback], note.errors[:content])
  end

  def test_validation_with_invalid_indent_by_many_spaces
    note = Note.new(:content => "* Title\r\n    * Indent")
    feedback = {
      :message => "has invalid indent",
      :lines   => [2]
    }

    refute(note.valid?)
    assert_equal([feedback], note.errors[:content])
  end

  def test_validation_with_invalid_indent_by_odd_spaces
    note = Note.new(:content => "* Title\r\n * Indent")
    feedback = {
      :message => "has invalid indent",
      :lines   => [2]
    }

    refute(note.valid?)
    assert_equal([feedback], note.errors[:content])
  end

  # actions

  def test_save_with_errors
    note = Note.new

    assert_no_difference("Version::Cycle.count", 1) do
      assert_no_difference("Note.count", 1) do
        refute(note.save)
      end
    end
  end

  def test_save_without_errors_at_line_after_deep_indent
    attributes = {
      :node    => nodes(:var),
      :content => <<-CONTENT.gsub(/^\s{8}/, "")
        * foo
          * bar
            * baz
              * qux
        * quux
      CONTENT
    }
    user = users(:oswald)
    note = Note.new(attributes).assign_to(user)

    assert_difference("Version::Cycle.count", 1) do
      assert_difference("Note.count", 1) do
        assert(note.save)
      end
    end
    assert_empty(note.errors)
  end

  def test_save_without_errors
    attributes = {
      :content => "* Test\r\n* This is test",
      :node    => nodes(:var)
    }
    user = users(:oswald)
    note = Note.new(attributes).assign_to(user)

    assert_difference("Version::Cycle.count", 1) do
      assert_difference("Note.count", 1) do
        assert(note.save)
      end
    end
    assert_empty(note.errors)
  end

  def test_update_with_errors
    note = notes(:linux_book)

    assert_no_difference("Version::Cycle.count", 1) do
      assert_not(note.update_attributes(:content => ""))
    end
  end

  def test_update_without_errors
    attributes = {
      :content => <<-CONTENT.gsub(/^\s{8}/, "")
        * New Little hard Linux beginner's Book
          * Getting Started
      CONTENT
    }
    note = notes(:linux_book)

    assert_difference("Version::Cycle.count", 1) do
      assert(note.update_attributes(attributes))
    end
    assert_empty(note.errors)
  end

  def test_delete
    note = notes(:shopping_list)

    assert_no_difference("Version::Cycle.count", 1) do
      assert_difference("Note.count", -1) do
        assert(note.delete)
      end
    end
    refute(Note.where(:id => note.id).exists?)
  end

  def test_destroy
    note = notes(:shopping_list)

    assert_difference("Version::Cycle.count", 1) do
      assert_difference("Note.count", -1) do
        assert(note.destroy)
      end
    end
    refute(Note.where(:id => note.id).exists?)
  end

  # visibility and assignment

  def test_availability_of_visible_to
    assert_respond_to(Note, :visible_to)
  end

  def test_availability_of_assign_to
    assert_respond_to(Note.new, :assign_to)
  end

  def test_relation_by_visible_to
    user = users(:weenie)
    relation = Note.visible_to(user)

    assert_kind_of(ActiveRecord::Relation, relation)
    assert_equal(["#{Note.table_name}.user_id = #{user.id}"],
      relation.where_values)
  end

  def test_assignment_by_assign_to
    user = users(:weenie)
    note = Note.new.assign_to(user)

    assert_kind_of(Note, note)
    assert_equal(user, note.user)
  end

  def test_owner_consistency_after_init
    user = users(:weenie)
    note = Note.new.assign_to(user)

    assert_equal(user.id, note.user_id)
    assert_equal(user.id, note.user_id_was)
  end

  def test_owner_consistency_after_transfer
    new_user = users(:weenie)
    original_note = notes(:wish_list)
    note = original_note.assign_to(new_user)

    assert_equal(new_user.id, note.user_id)
    assert_equal(new_user.id, note.user_id_was)
  end

  # restoration

  def test_restore_at_undo
    note = notes(:wish_list)
    note.update_attributes(:name => "* My Wishlist (private)")

    assert_difference("Version::Cycle.count", 1) do
      assert(note.versions.last.restore!)
    end

    note.reload

    assert_equal("My Wishlist", note.name)
  end

  def test_restore_at_redo
    note = notes(:wish_list)
    note.update_attributes(:content => "* My Wishlist (private)\r\n")
    version = note.versions.last
    version.restore!

    assert_difference("Version::Cycle.count", 1) do
      assert(version.next.restore!)
    end

    note.reload

    assert_equal("My Wishlist (private)", note.name)
  end

  # methods

  def test_cached_find_raises_exception_without_visible_to_scope
    assert_raise(ActiveRecord::RecordNotFound) do
      note = notes(:linux_book)
      Note.cached_find(note.id)
    end
  end

  def test_cached_find_raises_exception_if_missing_id_is_given
    assert_raise(ActiveRecord::RecordNotFound) do
      note = notes(:linux_book)
      Note.visible_to(note.user).cached_find(0)
    end
  end

  def test_cached_find_returns_cache_after_cache_was_created
    with_caching do
      note = notes(:linux_book)
      scoped = Note.visible_to(note.user)

      assert_equal(note, scoped.cached_find(note.id))

      mock = Minitest::Mock.new
      mock.expect(:take!, note) # not called
      Note.stub(:where, mock) do
        assert_equal(note, scoped.cached_find(note.id))
        assert_raise(MockExpectationError) do
          mock.verify
        end
      end
    end
  end

  def test_cached_find_loads_exact_record_after_cache_was_destroyed
    with_caching do
      note = notes(:wish_list)
      scoped = Note.visible_to(note.user)

      assert_equal(note, scoped.cached_find(note.id))
      assert(note.update_attribute(:name, "My New Wishlist"))

      note.reload

      #scoped.cached_find(note.id)
      #Rails.cache.clear

      mock = Minitest::Mock.new
      mock.expect(:take!, note)
      Note.stub(:where, mock) do
        assert_equal(note, scoped.cached_find(note.id))
        mock.verify
      end
    end
  end

  def test_name_with_blank_content
    note = notes(:linux_book)
    note.content = ""

    assert_empty(note.name)
  end

  def test_name_with_nil_content
    note = notes(:linux_book)
    note.content = nil

    assert_empty(note.name)
  end

  # private methods

  def test_content_must_not_contain_blank_line_catches_error_with_blank_line
    note = notes(:linux_book)
    note.content = "\r\n"
    note.send(:content_must_not_contain_blank_line)

    assert_not_empty(note.errors[:content])
  end

  def test_content_must_not_contain_blank_line_catches_error_with_blank_lines
    note = notes(:linux_book)
    note.content = "foo\r\n\r\nbar\r\n\r\n"
    note.send(:content_must_not_contain_blank_line)

    assert_not_empty(note.errors[:content])
  end

  def test_content_must_not_contain_blank_line_catches_error_with_whitespace
    note = notes(:linux_book)
    note.content = " \r\n"
    note.send(:content_must_not_contain_blank_line)

    assert_not_empty(note.errors[:content])
  end

  def test_content_must_be_valid_outline_syntax_without_bullet
    note = notes(:linux_book)
    note.content = "foo\r\nbar\r\n"
    note.send(:content_must_be_valid_outline_syntax)
    feedback = {
      :message => "must start with bullet points '* '",
      :lines   => [1, 2]
    }

    assert_equal([feedback], note.errors[:content])
  end

  def test_content_must_be_valid_indent_with_too_many_indent
    note = notes(:linux_book)
    note.content = "* foo\r\n    * bar\r\n"
    note.send(:content_must_be_valid_indent)
    feedback = {
      :message => "has invalid indent",
      :lines   => [2]
    }

    assert_equal([feedback], note.errors[:content])
  end

  def test_content_must_be_valid_indent_with_too_few_indent
    note = notes(:linux_book)
    note.content = "* foo\r\n * bar\r\n"
    note.send(:content_must_be_valid_indent)
    feedback = {
      :message => "has invalid indent",
      :lines   => [2]
    }

    assert_equal([feedback], note.errors[:content])
  end
end
