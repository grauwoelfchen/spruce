require "test_helper"

class CanAccessToStaticErrorsTest < Capybara::Rails::TestCase
  def test_404_not_found_error_page_has_content
    visit "/404"
    assert page.status_code, 404
    assert_content page, "Not Found :-p"
  end

  def test_422_unprocessable_entity_error_page_has_content
    visit "/422"
    assert page.status_code, 422
    assert_content page, "Unprocessable Entity ;("
  end

  def test_500_internal_server_error_page_has_content
    visit "/500"
    assert page.status_code, 500
    assert_content page, "Server Error :'("
  end
end
