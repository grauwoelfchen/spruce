require "test_helper"

class PagesHelperTest < ActionView::TestCase
  include PagesHelper

  def test_screenshot
    result = screenshot("test.png", "test image", "200x160")
    assert_match /href="\/images\/test\.png"/, result
    assert_match /target="_blank"/,            result
    assert_match /alt="test\simage"/,         result
    assert_match /height="160"/,              result
    assert_match /width="200"/,               result
    assert_match /src="\/images\/test\.png"/, result
  end

  def test_screenshot_without_size
    expected = <<-HTML.gsub(/\n|^\s*/, "")
<a href="/images/test.png" target="_blank">
  <img alt="test image" height="160" src="/images/test.png" width="200" />
</a>
    HTML
    assert_equal expected, screenshot("test.png", "test image")
  end

  def test_screenshot_without_alt
    expected = <<-HTML.gsub(/\n|^\s*/, "")
<a href="/images/test.png" target="_blank">
  <img height="80" src="/images/test.png" width="100" />
</a>
    HTML
    assert_equal expected, screenshot("test.png", nil, "100x80")
  end
end
