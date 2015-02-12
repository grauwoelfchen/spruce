require "test_helper"

class SitemapControllerTest < ActionController::TestCase
  def test_get_index
    get(:index, :format => "xml")

    assert_template(:layout => nil)
    assert_template(:index)
    assert_response(:success)
  end
end
