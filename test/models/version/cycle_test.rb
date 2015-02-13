require "test_helper"

class Version::CycleTest < ActiveSupport::TestCase
  fixtures(:nodes, :users, :notes)

  setup(:build_tree)

  # properties

  def test_properties
    cycle = Version::Cycle.new

    assert_respond_to(cycle, :event)
    assert_respond_to(cycle, :whodunnit)
    assert_respond_to(cycle, :object)
  end

  # associations

  def test_associations
    cycle = Version::Cycle.new

    assert_respond_to(cycle, :user)
    assert_respond_to(cycle, :item)
  end

  # validations

  def test_validation_without_event
    cycle = Version::Cycle.new(:event => "")

    refute(cycle.valid?)
    assert_equal(["can't be blank"], cycle.errors[:event])
  end

  # actions

  def test_save_with_create_node
    user = users(:tim)
    node = Node.new(:name => "Tim's node").assign_to(user)
    node.parent = nodes(:tim_s_home)

    assert_difference("Version::Cycle.count", 1) do
      assert_difference("Node.count", 1) do
        assert(node.save)
      end
    end
    assert_empty(node.errors)
  end

  def test_save_with_create_note
    attributes = {
      :content => "* Test\r\n* This is test",
      :node    => nodes(:var)
    }
    user = users(:tim)
    note = Note.new(attributes).assign_to(user)

    assert_difference("Version::Cycle.count", 1) do
      assert_difference("Note.count", 1) do
        assert(note.save)
      end
    end
    assert_empty(note.errors)
  end

  def test_save_with_destroy_node
    node = nodes(:bob_s_home)
    child = node.children.first

    assert_difference("Version::Cycle.count", 1) do
      assert_difference("Node.count", -3) do
        assert(node.destroy)
      end
    end
    refute(Node.where(:id => node.id).exists?)
    refute(Node.where(:id => child.id).exists?)
  end

  def test_save_with_destroy_note
    note = notes(:shopping_list)

    assert_difference("Version::Cycle.count", 1) do
      assert_difference("Note.count", -1) do
        assert(note.destroy)
      end
    end
    refute(Note.where(:id => note.id).exists?)
  end


  private

    def build_tree
      Node.rebuild!
    end
end
