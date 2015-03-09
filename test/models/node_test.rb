require "test_helper"

class NodeTest < ActiveSupport::TestCase
  include CachingHelper

  fixtures(:nodes, :users, :notes)

  setup(:build_tree)

  # properties

  def test_properties
    node = Node.new

    assert_respond_to(node, :name)
    assert_respond_to(node, :parent_id)
  end

  # associations

  def test_associations
    node = Node.new

    assert_respond_to(node, :user)
    assert_respond_to(node, :notes)
    assert_respond_to(node, :recorded_changes)
    assert_respond_to(node, :versions)
  end

  # validations

  def test_validation_without_name
    node = Node.new(:name => "")

    refute(node.valid?)
    assert_equal(["can't be blank"], node.errors[:name])
  end

  def test_validation_with_duplicate_name
    existing_node = nodes(:var)
    node = Node.new(
      :name   => "var",
      :parent => existing_node.parent
    ).assign_to(existing_node.user)

    refute(node.valid?)
    assert_equal(["has already been taken"], node.errors[:name])
  end

  def test_validation_with_reserved_names
    node = Node.new(:name => "root")

    refute(node.valid?)
    assert_equal(["root is reserved"], node.errors[:name])
  end

  def test_validation_with_too_long_name
    node = Node.new(:name => "long" * 100)

    refute(node.valid?)
    assert_equal(["is too long (maximum is 32 characters)"], node.errors[:name])
  end

  def test_validation_with_dot_name
    node = Node.new(:name => ".test")

    refute(node.valid?)
    assert_equal(["can't start with ."], node.errors[:name])
  end

  def test_validation_with_invalid_name
    node = Node.new
    node.name = "~test"

    refute(node.valid?)
    assert_equal(["can't contain %~/\\*`"], node.errors[:name])

    node.name = "%test"

    refute(node.valid?)
    assert_equal(["can't contain %~/\\*`"], node.errors[:name])

    node.name = "foo/bar"

    refute(node.valid?)
    assert_equal(["can't contain %~/\\*`"], node.errors[:name])
  end

  def test_validation_without_user_id
    node = Node.new(:user_id => nil)

    refute(node.valid?)
    assert_equal(["can't be blank"], node.errors[:user_id])
  end

  def test_validation_without_parent_id
    node = Node.new(:parent_id => nil)

    refute(node.valid?)
    assert_equal(["can't be blank"], node.errors[:parent_id])
  end

  def test_validation_with_invalid_parent_id
    node = nodes(:weenie_s_home)
    node.parent = node

    refute(node.valid?)
    assert_equal(["You cannot add an ancestor as a descendant"],
      node.errors[:parent_id])
  end

  # actions

  def test_save_with_errors
    node = Node.new

    assert_no_difference("Version::Cycle.count", 1) do
      assert_no_difference("Node.count", 1) do
        assert_not(node.save)
      end
    end
  end

  def test_save_without_errors
    user = users(:oswald)
    node = Node.new(:name => "oswald's node").assign_to(user)
    node.parent = nodes(:oswald_s_home)

    assert_difference("Version::Cycle.count", 1) do
      assert_difference("Node.count", 1) do
        assert(node.save)
      end
    end
    assert_empty(node.errors)
  end

  def test_update_with_errors
    node = nodes(:oswald_s_home)

    assert_no_difference("Version::Cycle.count", 1) do
      assert_not(node.update_attributes(:name => ""))
    end
  end

  def test_update_without_errors
    node = nodes(:var)

    assert_difference("Version::Cycle.count", 1) do
      assert(node.update_attributes(:name => "oswald's awesome home"))
    end
    assert_empty(node.errors)
  end

  def test_delete
    node = nodes(:weenie_s_home)
    child = node.children.first

    assert_no_difference("Version::Cycle.count", 1) do
      assert_difference("Node.count", -1) do
        node.delete
      end
    end

    refute(Node.where(:id => node.id).exists?)
    assert(Node.where(:parent_id => node.id).exists?)
    assert(Node.where(:id => child.id).exists?)
    assert(Note.where(:node => node).exists?)
  end

  def test_destroy
    node = nodes(:weenie_s_home)
    child = node.children.first

    assert_difference("Version::Cycle.count", 1) do
      assert_difference("Node.count", -3) do
        assert(node.destroy)
      end
    end

    refute(Node.where(:id => node.id).exists?)
    refute(Node.where(:id => child.id).exists?)
    assert_empty(Node.where(:user => node.user))
    assert_empty(Note.where(:node => node))
  end

  # visibility and assignment

  def test_availability_of_visible_to
    assert_respond_to(Node, :visible_to)
  end

  def test_availability_of_assign_to
    assert_respond_to(Node.new, :assign_to)
  end

  def test_relation_by_visible_to
    user = users(:weenie)
    relation = Node.visible_to(user)

    assert_kind_of(ActiveRecord::Relation, relation)
    assert_equal(["#{Node.table_name}.user_id = #{user.id}"],
      relation.where_values)
  end

  def test_assignment_by_assign_to
    node = Node.new
    user = users(:weenie)
    result = node.assign_to(user)

    assert_kind_of(Node, result)
    assert_equal(user, result.user)
  end

  def test_owner_consistency_after_init
    user = users(:weenie)
    node = Node.new.assign_to(user)

    assert_equal(user.id, node.user_id)
    assert_equal(user.id, node.user_id_was)
  end

  def test_owner_consistency_after_transfer
    new_user = users(:weenie)
    original_node = nodes(:oswald_s_home)
    node = original_node.assign_to(new_user)

    assert_equal(new_user.id, node.user_id)
    assert_equal(new_user.id, node.user_id_was)
  end

  # restoration

  def test_restore_at_undo
    node = nodes(:var)
    node.update_attributes(:name => "var v2")

    assert_difference("Version::Cycle.count", 1) do
      assert(node.versions.last.restore!)
    end

    node.reload

    assert_equal("var", node.name)
  end

  def test_restore_at_redo
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    version = node.versions.last
    version.restore!

    assert_difference("Version::Cycle.count", 1) do
      assert version.next.restore!
    end

    node.reload

    assert_equal("var v2", node.name)
  end

  # methods

  def test_cached_find_raises_exception_if_missing_id_is_given
    assert_raise(ActiveRecord::RecordNotFound) do
      Node.cached_find(0)
    end
  end

  def test_cached_find_returns_cache_after_cache_was_created
    with_caching do
      node = nodes(:var)

      assert_equal(node, Node.cached_find(node.id))

      mock = Minitest::Mock.new
      mock.expect(:take!, :not_called)
      Node.stub(:where, mock) do
        assert_equal(node, Node.cached_find(node.id))
        assert_raise(MockExpectationError) do
          mock.verify
        end
      end
    end
  end

  def test_cached_find_loads_exact_record_after_cache_was_destroyed
    with_caching do
      node = nodes(:var)

      assert_equal(node, Node.cached_find(node.id))
      assert(node.update_attribute(:name, "usr"))

      node.reload

      mock = Minitest::Mock.new
      mock.expect(:take!, node)
      Node.stub(:where, mock) do
        assert_equal(node, Node.cached_find(node.id))
        mock.verify
      end
    end
  end

  def test_roots
    roots = Node.roots

    assert_equal(Node.where(:parent_id => nil).length, roots.length)
  end

  def test_paths
    node = nodes(:lib)

    assert_kind_of(ActiveRecord::Relation, node.paths)
    assert_equal([nil, "var", "lib"], node.paths.map(&:name))
  end

  private

    def build_tree
      Node.rebuild!
    end
end
