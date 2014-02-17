require "test_helper"

class RoutesTest < ActionDispatch::IntegrationTest
  def test_route_to_pages
    assert_routing({ :method => "get", :path => "/" }, { :controller => "pages", :action => "index" })
  end

  def test_route_to_sessions
    assert_routing({ :method => "delete", :path => "/logout" }, { :controller => "sessions", :action => "destroy" })
    assert_routing({ :method => "get",    :path => "/login" },  { :controller => "sessions", :action => "new" })
    assert_routing({ :method => "post",   :path => "/login" },  { :controller => "sessions", :action => "create" })
  end

  def test_route_to_users
    assert_routing({ :method => "get",  :path => "/signup" },               { :controller => "users", :action => "new" })
    assert_routing({ :method => "post", :path => "/signup" },               { :controller => "users", :action => "create" })
    assert_routing({ :method => "get",  :path => "/users/token/activate" }, { :controller => "users", :action => "activate", :token => "token" })
  end

  def test_route_to_nodes
    assert_routing({ :method => "get",    :path => "/b/1/b" },     { :controller => "nodes", :action => "index",  :node_id => "1" })
    assert_routing({ :method => "get",    :path => "/b/1/b/new" }, { :controller => "nodes", :action => "new",    :node_id => "1" })
    assert_routing({ :method => "post",   :path => "/b/1/b" },     { :controller => "nodes", :action => "create", :node_id => "1" })
    assert_routing({ :method => "get",    :path => "/b" },         { :controller => "nodes", :action => "index" })
    assert_routing({ :method => "get",    :path => "/b/1" },       { :controller => "nodes", :action => "show",    :id => "1" })
    assert_routing({ :method => "get",    :path => "/b/1/edit" },  { :controller => "nodes", :action => "edit",    :id => "1" })
    assert_routing({ :method => "put",    :path => "/b/1" },       { :controller => "nodes", :action => "update",  :id => "1" })
    assert_routing({ :method => "delete", :path => "/b/1" },       { :controller => "nodes", :action => "destroy", :id => "1" })
  end

  def test_route_to_notes
    assert_routing({ :method => "get",    :path => "/b/1/l" },     { :controller => "notes", :action => "index",  :node_id => "1" })
    assert_routing({ :method => "get",    :path => "/b/1/l/new" }, { :controller => "notes", :action => "new",    :node_id => "1" })
    assert_routing({ :method => "post",   :path => "/b/1/l" },     { :controller => "notes", :action => "create", :node_id => "1" })
    assert_routing({ :method => "get",    :path => "/l/1" },       { :controller => "notes", :action => "show",    :id => "1" })
    assert_routing({ :method => "get",    :path => "/l/1/edit" },  { :controller => "notes", :action => "edit",    :id => "1" })
    assert_routing({ :method => "put",    :path => "/l/1" },       { :controller => "notes", :action => "update",  :id => "1" })
    assert_routing({ :method => "delete", :path => "/l/1" },       { :controller => "notes", :action => "destroy", :id => "1" })
  end
end
