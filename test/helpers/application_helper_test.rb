require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  fixtures(:nodes, :notes)

  def test_include_action_view_url_helper
    assert(self.class.ancestors.include?(ActionView::Helpers::UrlHelper))
  end

  def test_orig_current_page
    assert(self.respond_to?(:orig_current_page?))
  end

  def test_current_page_at_other_page
    request = Minitest::Mock.new
    request.expect(:get?, true)
    request.expect(:path, "/l")
    self.request = request

    assert_equal(false, current_page?("nodes#index"))
    request.verify
  end

  def test_current_page_at_exact_page
    request = Minitest::Mock.new
    request.expect(:get?, true)
    request.expect(:path, "/b")
    self.request = request

    assert_equal(true, current_page?("nodes#index"))
    request.verify
  end

  def test_current_page_in_other_pages
    stub_method(:controller_name, "others")
    stub_method(:action_name, "somthing")

    assert_equal(false, current_page_in?(["sessions#new"]))
  end

  def test_current_page_in_at_exact_pages
    stub_method(:controller_name, "sessions")
    stub_method(:action_name, "new")

    assert_equal(true, current_page_in?(["sessions#new"]))
  end

  def test_shallow_args_with_existing_node
    node = nodes(:var)

    assert_equal(node, shallow_args(node))
  end

  def test_shallow_args_with_new_node
    parent = nodes(:var)
    node = Node.new(:parent => parent)

    assert_equal([parent, node], shallow_args(node))
  end

  def test_shallow_args_with_note
    node = nodes(:var)
    note = notes(:linux_book)

    assert_equal([node, note], shallow_args([node, note]))
  end

  def test_parenthesis_styles_at_nodes_new
    stub_method(:controller_name, "nodes")
    stub_method(:action_name, "new")
    expected = {
      :node => {:new => "parenthesis-highlight"},
      :note => {}
    }

    assert_equal(expected, parenthesis_styles)
  end

  def test_parenthesis_styles_at_notes_edit
    stub_method(:controller_name, "notes")
    stub_method(:action_name, "edit")
    expected = {
      :node => {},
      :note => {:edit => "parenthesis-highlight"}
    }

    assert_equal(expected, parenthesis_styles)
  end

  def test_render_paths_at_nodes_show_to_1_depth
    Node.rebuild!
    node = nodes(:var)
    stub_method(:current_page?, true, ["nodes#show"])
    stub_method(:params, {:id => node.id.to_s})

    expected = <<-HTML.gsub(/^\s{6}|\n/, "")
      / <a href="/b">root</a> /
       <span class="pwd">#{node.name}</span>
    HTML

    assert_equal(expected, render_paths(node.paths))
  end

  def test_render_paths_at_nodes_show_to_2_depth
    Node.rebuild!
    node = nodes(:lib)
    stub_method(:current_page?, true, ["nodes#show"])
    stub_method(:params, {:id => node.id.to_s})

    expected = <<-HTML.gsub(/^\s{6}|\n/, "")
      / <a href="/b">root</a> /
       <a href="/b/#{node.parent.id}">#{node.parent.name}</a> /
       <span class="pwd">#{node.name}</span>
    HTML

    assert_equal(expected, render_paths(node.paths))
  end

  private

    def stub_method(name, return_value, args=[])
      self.class.send(:define_method, name) do |*actual_args|
        unless args == actual_args
          raise ArgumentError.new("expected args do not match")
        end
        return_value
      end
    end
end
