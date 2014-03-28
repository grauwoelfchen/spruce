require 'test_helper'

class VersionsControllerTest < ActionController::TestCase
  fixtures :nodes, :users

  setup    :login, :initialize_node
  teardown :logout

  # actions

  def test_post_revert_with_invalid_version
    post :revert, :id => "invalid"
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_post_revert_with_others_version
    request.env["HTTP_REFERER"] = nodes_url
    node = nodes(:work)
    node.update_attributes(:name => "Bob's Home v2")
    post :revert, :id => node.versions.last.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_post_revert_with_params_redo_false
    request.env["HTTP_REFERER"] = nodes_url
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    attributes = {
      :id   => node.versions.last.id,
      :redo => "false"
    }
    post :revert, attributes
    assert_response :redirect
    assert_redirected_to nodes_url
    assert_equal \
      "Undid update. redo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
  end

  def test_post_revert_with_params_redo_true
    request.env["HTTP_REFERER"] = nodes_url
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    node.versions.last.reify.save!
    attributes = {
      :id   => node.versions.last.id,
      :redo => "true",
    }
    post :revert, attributes
    assert_response :redirect
    assert_redirected_to nodes_url
    assert_equal \
      "Undid update. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
  end

  # methods

  def test_redo_link_with_params_redo_false
    controller = VersionsController.new
    controller.stubs(:revert_version_path).returns("/versions/2/revert?redo=true")
    controller.stubs(:params).returns(:redo => "false")
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    version = node.versions.last
    controller.instance_variable_set(:@version, version)
    expected = <<-LINK.gsub(/^\s{6}|\n/, "")
      <a data-method="post" href="/versions/2/revert?redo=true" rel="nofollow">redo</a>
    LINK
    assert_equal expected, controller.send(:redo_link)
  end

  def test_redo_link_with_params_redo_true
    controller = VersionsController.new
    controller.stubs(:revert_version_path).returns("/versions/2/revert?redo=false")
    controller.stubs(:params).returns(:redo => "true")
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    version = node.versions.last
    version.reify.save!
    controller.instance_variable_set(:@version, version)
    expected = <<-LINK.gsub(/^\s{6}|\n/, "")
      <a data-method="post" href="/versions/2/revert?redo=false" rel="nofollow">undo</a>
    LINK
    assert_equal expected, controller.send(:redo_link)
  end

  private

  def login
    user = users(:tim)
    login_user(user)
  end

  def initialize_node
    Node.rebuild!
  end

  def logout
    logout_user
  end
end
