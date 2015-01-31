require 'test_helper'

class VersionsControllerTest < ActionController::TestCase
  include RequestHelper

  fixtures :nodes, :notes, :users

  setup :login, :build_node_tree
  teardown :logout

  # actions

  # revert

  def test_get_revert_node_with_invalid_version
    params = {
      :id   => "invalid",
      :type => "b"
    }
    get :revert, params
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_revert_note_with_invalid_version
    params = {
      :id   => "invalid",
      :type => "l"
    }
    get :revert, params
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_get_revert_node_with_valid_version
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    request.env["HTTP_REFERER"] = nodes_url
    params = {
      :id   => node.versions.last.id,
      :type => "b"
    }
    get :revert, params
    assert_response :success
    assert_template :revert
  end

  def test_get_revert_note_with_valid_version
    note = notes(:wish_list)
    note.update_attributes(:content => "* New Wishlist\r\n")
    request.env["HTTP_REFERER"] = note_url(note)
    params = {
      :id   => note.versions.last.id,
      :type => "l"
    }
    get :revert, params
    assert_response :success
    assert_template :revert
  end

  # restore

  def test_post_restore_node_with_invalid_version
    params = {
      :id   => "invalid",
      :type => "b"
    }
    post :restore, params

    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_post_restore_note_with_invalid_version
    params = {
      :id   => "invalid",
      :type => "l"
    }
    post :restore, params
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_post_restore_node_with_others_version
    bob_s_node = nodes(:work)
    bob_s_node.update_attributes(:name => "Bob's Home v2")
    request.env["HTTP_REFERER"] = nodes_url
    params = {
      :id   => bob_s_node.versions.last.id,
      :type => "b"
    }
    post :restore, params
    assert_response :redirect
    assert_redirected_to root_url
  end

  def test_post_restore_note_with_others_version
    bob_s_note = notes(:shopping_list)
    bob_s_note.update_attributes(:content => "* Shopping list v2\r\n")
    request.env["HTTP_REFERER"] = note_url(bob_s_note)
    params = {
      :id   => bob_s_note.versions.last.id,
      :type => "l"
    }
    post :restore, params
    assert_response :redirect
    assert_redirected_to root_url
  end

  # restore create

  # FIXME

  # restore update

  def test_post_restore_update_node_on_undo
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    request.env["HTTP_REFERER"] = nodes_url
    params = {
      :id   => node.versions.last.id,
      :type => "b",
      :redo => "false"
    }
    post :restore, params
    assert_response :redirect
    assert_redirected_to nodes_url
    assert_equal \
      "Undid update. redo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
  end

  def test_post_restore_update_note_on_undo
    note = notes(:wish_list)
    request.env["HTTP_REFERER"] = note_url(note)
    note.update_attributes(:name => "* My Wishlist v2")
    params = {
      :id   => note.versions.last.id,
      :type => "l",
      :redo => "false"
    }
    post :restore, params
    assert_response :redirect
    assert_redirected_to note_url(note)
    assert_equal \
      "Undid update. redo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
  end

  def test_post_restore_update_node_on_redo
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    node.versions.last.restore!
    request.env["HTTP_REFERER"] = nodes_url
    params = {
      :id   => node.versions.last.id,
      :type => "b",
      :redo => "true",
    }
    post :restore, params
    assert_response :redirect
    assert_redirected_to nodes_url
    assert_equal \
      "Undid update. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
  end

  def test_post_restore_update_note_on_redo
    note = notes(:wish_list)
    note.update_attributes(:name => "var v2")
    note.versions.last.restore!
    request.env["HTTP_REFERER"] = note_url(note)
    params = {
      :id   => note.versions.last.id,
      :type => "l",
      :redo => "true",
    }
    post :restore, params
    assert_response :redirect
    assert_redirected_to note_url(note)
    assert_equal \
      "Undid update. undo",
      ActionController::Base.helpers.strip_tags(flash[:notice])
  end

  # restore destroy

  # FIXME

  # methods

  def test_redo_link_for_node_on_undo
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    version = node.versions.last
    version.restore!

    controller = VersionsController.new
    controller.instance_variable_set(:@version, version)

    with_params(controller, :type => "b", :redo => "false") do
      expected = <<-LINK.gsub(/^\s{8}|\n/, "")
        <a data-method="post" href="/v/#{version.next.id}/b/revert?redo=true"
         rel="nofollow">redo</a>
      LINK
      assert_equal expected, controller.send(:redo_link)
    end
  end

  def test_redo_link_for_node_on_redo
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    version = node.versions.last
    version.restore!

    controller = VersionsController.new
    controller.instance_variable_set(:@version, version)

    with_params(controller, :type => "b", :redo => "true") do
      expected = <<-LINK.gsub(/^\s{8}|\n/, "")
        <a data-method="post" href="/v/#{version.next.id}/b/revert?redo=false"
         rel="nofollow">undo</a>
      LINK
      assert_equal expected, controller.send(:redo_link)
    end
  end

  def test_back_url_for_new_node_with_referer
    attributes = {
      :name => "New node",
      :user => users(:tim)
    }
    user = users(:tim)
    node = nodes(:tim_s_home).children.new(attributes)
    node.save
    version = node.versions.last
    version.restore!

    controller = VersionsController.new
    controller.instance_variable_set(:@version, version)

    with_referer(controller, node_url(node)) do
      assert_equal :back, controller.send(:back_url)
    end
  end

  def test_back_url_for_new_node_without_referer
    attributes = {
      :name => "New node",
      :user => users(:tim)
    }
    user = users(:tim)
    node = nodes(:tim_s_home).children.new(attributes)
    node.save
    version = node.versions.last
    version.restore!

    controller = VersionsController.new
    controller.instance_variable_set(:@version, version)

    with_referer(controller, nil) do
      assert_equal nodes_url, controller.send(:back_url)
    end
  end

  def test_back_url_for_new_note
    attributes = {
      :content => "* New note\r\n",
      :user    => users(:tim),
    }
    note = nodes(:tim_s_home).notes.new(attributes)
    note.save
    version = note.versions.last
    version.restore!

    controller = VersionsController.new
    controller.instance_variable_set(:@version, version)

    with_request(controller) do
      assert_equal node_url(version.item.node), controller.send(:back_url)
    end
  end

  def test_back_url_for_node_with_referer
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    version = node.versions.last
    version.restore!

    controller = VersionsController.new
    controller.instance_variable_set(:@version, version)

    with_referer(controller, node_url(node)) do
      assert_equal :back, controller.send(:back_url)
    end
  end

  def test_back_url_for_note_with_referer
    note = notes(:linux_book)
    note.update_attributes(:content => "* More hard Linux beginner's Book\r\n")
    version = note.versions.last
    version.restore!

    controller = VersionsController.new
    controller.instance_variable_set(:@version, version)

    with_referer(controller, note_url(note)) do
      assert_equal :back, controller.send(:back_url)
    end
  end

  def test_back_url_for_node_without_referer
    node = nodes(:var)
    node.update_attributes(:name => "var v2")
    version = node.versions.last
    version.restore!

    controller = VersionsController.new
    controller.instance_variable_set(:@version, version)

    with_referer(controller, nil) do
      assert_equal nodes_url, controller.send(:back_url)
    end
  end

  def test_back_url_for_note_without_referer
    note = notes(:linux_book)
    note.update_attributes(:content => "* More hard Linux beginner's Book\r\n")
    version = note.versions.last
    version.restore!

    controller = VersionsController.new
    controller.instance_variable_set(:@version, version)

    with_referer(controller, nil) do
      assert_equal nodes_url, controller.send(:back_url)
    end
  end

  private

    def login
      user = users(:tim)
      login_user(user)
    end

    def build_node_tree
      Node.rebuild!
    end

    def logout
      logout_user
    end
end
