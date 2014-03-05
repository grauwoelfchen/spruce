require "test_helper"

class NodeTest < ActiveSupport::TestCase
  fixtures :nodes, :users, :notes

  setup :build_tree

  # properties

  def test_properties
    node = Node.new
    assert_respond_to node, :name
    assert_respond_to node, :parent_id
  end

  # associations

  def test_associations
    node = Node.new
    assert_respond_to node, :user
    assert_respond_to node, :notes
  end

  # validations

  def test_validation_without_name
    node = Node.new(:name => "")
    node.valid?
    assert_equal ["can't be blank"], node.errors[:name]
  end

  def test_validation_with_dot_name
    node = Node.new(:name => ".test")
    node.valid?
    assert_equal ["can't start with ."], node.errors[:name]
  end

  def test_validation_with_too_long_name
    node = Node.new(:name => "long" * 100)
    node.valid?
    assert_equal ["is too long (maximum is 32 characters)"], node.errors[:name]
  end

  def test_validation_with_invalid_name
    node = Node.new(:name => "~test")
    node.valid?
    assert_equal ["can't contain %~/\\*`"], node.errors[:name]
  end

  def test_validation_with_duplicate_name
    existing_node = nodes(:var)
    node = Node.new(:name => "var", :parent => existing_node.parent).assign_to(existing_node.user)
    node.valid?
    assert_equal ["has already been taken"], node.errors[:name]
  end

  def test_validation_without_user_id
    node = Node.new(:user_id => nil)
    node.valid?
    assert_equal ["can't be blank"], node.errors[:user_id]
  end

  def test_validation_without_parent_id
    node = Node.new(:parent_id => nil)
    node.valid?
    assert_equal ["can't be blank"], node.errors[:parent_id]
  end

  def test_validation_with_invalid_parent_id
    node = nodes(:bob_s_home)
    node.parent = node
    node.valid?
    assert_equal ["You cannot add an ancestor as a descendant"], node.errors[:parent_id]
  end

  # actions

  def test_save_with_errors
    node = Node.new
    assert_not node.save
  end

  def test_save_without_errors
    user = users(:tim)
    node = Node.new(:name => "Tim's node").assign_to(user)
    node.parent = nodes(:tim_s_home)
    assert node.save
  end

  def test_update_with_errors
    node = nodes(:tim_s_home)
    assert_not node.update_attributes(:name => "")
  end

  def test_update_without_errors
    node = nodes(:var)
    assert node.update_attributes(:name => "Tim's awesome home")
  end

  def test_delete
    node = nodes(:bob_s_home)
    node.delete
    child = node.children.first
    assert_nil Node.where(:id => node.id).first
    assert Node.where(:parent_id => node.id).present?
    assert Note.where(:node => node).present?
  end

  def test_destroy
    node = nodes(:bob_s_home)
    node.destroy
    assert_nil Node.where(:id => node.id).first
    assert Node.where(:user => node.user).empty?
    assert Note.where(:node => node).empty?
  end

  # included methods

  def test_responding_to_visible_to
    assert_respond_to Node, :visible_to
  end

  def test_responding_to_assign_to
    node = Node.new
    assert_respond_to node, :assign_to
  end

  def test_visible_to
    user = users(:bob)
    assert_kind_of ActiveRecord::Relation, Node.visible_to(user)
  end

  def test_assign_to
    node = Node.new
    user = users(:bob)
    result = node.assign_to(user)
    assert_kind_of Node, result
    assert_equal user, result.user
  end

  def test_roots
    roots = Node.roots
    assert_equal Node.where(:parent_id => nil).length, roots.length
  end

  # methods

  def test_paths
    node = nodes(:lib)
    assert_kind_of ActiveRecord::Relation, node.paths
    assert_equal ["Tim's Home", "var", "lib"], node.paths.map(&:name)
  end

  private

  def build_tree
    Node.rebuild!
  end
end
