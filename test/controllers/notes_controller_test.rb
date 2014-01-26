require 'test_helper'

class NotesControllerTest < ActionController::TestCase

  def test_get_index
    get :index
    assert_response :success
  end
end
