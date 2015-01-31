require "test_helper"

class CanAccessToStaticErrorsTest < Capybara::Rails::TestCase
  def test_404_not_found_error_page_has_content
    visit "/404"
    assert_equal 200, page.status_code
    assert_content "Not Found :-p"
  end

  def test_406_not_acceptable_error_page_has_content
    visit "/406"
    assert_equal 200, page.status_code
    assert_content "Not Acceptable :-p"
  end

  def test_422_unprocessable_entity_error_page_has_content
    visit "/422"
    assert_equal 200, page.status_code
    assert_content "Unprocessable Entity ;("
  end

  def test_500_internal_server_error_page_has_content
    visit "/500"
    assert_equal 200, page.status_code
    assert_content "Server Error :'("
  end
end
