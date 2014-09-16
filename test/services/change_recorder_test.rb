require "test_helper"

class ChangeRecorderTest < ActiveSupport::TestCase
  fixtures :nodes, :notes

  def test_recording_of_update_node
    recorder = ChangeRecorder.new(nodes(:var))
    assert_difference ["Version::Cycle.count", "Version::Ring.count"], 1 do
      assert recorder.update_attributes(:name => "Tim's awesome home")
    end
  end

  def test_recording_of_update_note
    attributes = {
      :content => <<-NOTE
* New Little hard Linux beginner's Book
  * Getting Started
      NOTE
    }
    recorder = ChangeRecorder.new(notes(:linux_book))
    assert_difference ["Version::Cycle.count", "Version::Layer.count"], 1 do
      assert recorder.update_attributes(attributes)
    end
  end
end
