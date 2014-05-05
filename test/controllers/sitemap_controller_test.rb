require "test_helper"

class SitemapControllerTest < ActionController::TestCase
  def test_get_index
    get :index, :format => "xml"
    assert_response :success
  end
end
