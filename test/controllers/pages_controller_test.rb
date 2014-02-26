require "test_helper"

class PagesControllerTest < ActionController::TestCase
  def test_get_index
    get :index
    assert_response :success
  end

  def test_get_introduction
    get :introduction
    assert_response :success
  end

  def test_get_changelog
    get :changelog
    assert_response :success
  end
end
