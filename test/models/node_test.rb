require "test_helper"

class NodeTest < ActiveSupport::TestCase
  fixtures :nodes, :users

  # properties

  def test_properties
    node = Node.new
    assert_respond_to node, :name
    assert_respond_to node, :parent_id
    assert_respond_to node, :user_id
  end

  # validations

  def test_validation_without_name
    node = Node.new(:name => "")
    node.valid?
    assert_equal 1, node.errors[:name].length
    assert_equal "can't be blank", node.errors[:name].first
  end

  def test_validation_with_duplicate_name
    user = users(:tim)
    existing_node = nodes(:root).assign_to(user)
    existing_node.save!
    node = Node.new(:name => "root", :parent => existing_node.parent).assign_to(user)
    node.valid?
    assert_equal 1, node.errors[:name].length
    assert_equal "has already been taken", node.errors[:name].first
  end

  def test_validation_without_user_id
    node = Node.new(:user_id => nil)
    node.valid?
    assert_equal 1, node.errors[:user_id].length
    assert_equal "can't be blank", node.errors[:user_id].first
  end

  def test_validation_with_invalid_parent_id
    user = users(:bob)
    node = Node.new(:name => "test", :user => user)
    node.save!
    node.parent = node
    node.valid?
    assert_equal 1, node.errors[:parent_id].length
    assert_equal "You cannot add an ancestor as a descendant", node.errors[:parent_id].first
  end

  # save & update

  def test_save_with_errors
    node = Node.new
    assert_not node.save, "Saved the node with errors"
  end

  def test_save_without_errors
    attributes = {
      :name => "Tim's root node"
    }
    user = users(:tim)
    node = Node.new(attributes).assign_to(user)
    assert node.save, "Failed to save the node without errors"
  end

  def test_update_with_errors
    node = nodes(:tim_s_home)
    assert_not node.update_attributes(:name => ""), "Updated the node with errors"
  end

  def test_update_without_errors
    attributes = {
      :name =>  "Tim's awesome home"
    }
    node = nodes(:tim_s_home)
    assert node.update_attributes(attributes), "Failed to update the node without errors"
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
end

