require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper
  
  fixtures :nodes, :notes

  def test_include_action_view_url_helper
    assert self.class.ancestors.include?(ActionView::Helpers::UrlHelper)
  end

  def test_orig_current_page
    assert self.respond_to?(:orig_current_page?)
  end

  def test_current_page_at_other_page
    request = mock("Request")
    request.stubs(:get?).returns(true)
    request.stubs(:path).returns("/l")
    self.stubs(:request).returns(request)
    assert_not current_page?("nodes#index")
  end

  def test_current_page_at_exact_page
    request = mock("Request")
    request.stubs(:get?).returns(true)
    request.stubs(:path).returns("/b")
    self.stubs(:request).returns(request)
    assert current_page?("nodes#index")
  end

  def test_current_page_in_at_other_pages
    self.stubs(:controller_name).returns("other")
    self.stubs(:action_name).returns("something")
    assert_not current_page_in?(["sessions#new", "sessions#create"])
  end

  def test_current_page_in_at_exact_pages
    self.stubs(:controller_name).returns("sessions")
    self.stubs(:action_name).returns("new")
    assert current_page_in?(["sessions#new", "sessions#create"])
  end

  def test_shallow_args_with_existed_node
    node = nodes(:var)
    assert_equal node, shallow_args(node)
  end

  def test_shallow_args_with_new_node
    parent = nodes(:var)
    node   = Node.new(:parent => parent)
    assert_equal [parent, node], shallow_args(node)
  end

  def test_shallow_args_with_note
    node = nodes(:var)
    note = notes(:linux_book)
    assert_equal [node, note], shallow_args([node, note])
  end

  def test_parenthesis_styles_at_nodes_new
    self.stubs(:controller_name).returns("nodes")
    self.stubs(:action_name).returns("new")
    expected = {
      :node => {:new => "parenthesis-highlight"},
      :note => {}
    }
    assert_equal expected, parenthesis_styles
  end

  def test_parenthesis_styles_at_notes_edit
    self.stubs(:controller_name).returns("notes")
    self.stubs(:action_name).returns("edit")
    expected = {
      :node => {},
      :note => {:edit => "parenthesis-highlight"}
    }
    assert_equal expected, parenthesis_styles
  end

  def test_render_paths_at_nodes_show_to_1_depth
    Node.rebuild!
    node = nodes(:var)
    self.stubs(:current_page?).returns(true)
    self.stubs(:params).returns(:id => node.id.to_s)
    expected = <<-HTML.gsub(/^\s{6}|\n/, "")
      / <a href="/b">root</a> / <span class="wd">#{node.name}</span>
    HTML
    assert_equal expected, render_paths(node.paths)
  end

  def test_render_paths_at_nodes_show_to_2_depth
    Node.rebuild!
    node = nodes(:lib)
    self.stubs(:current_page?).returns(true)
    self.stubs(:params).returns(:id => node.id.to_s)
    expected = <<-HTML.gsub(/^\s{6}|\n/, "")
      / <a href="/b">root</a> / <a href="/b/#{node.parent.id}">#{node.parent.name}</a> / <span class="wd">#{node.name}</span>
    HTML
    assert_equal expected, render_paths(node.paths)
  end
end
