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
    assert_routing({ :method => "get",    :path => "/nodes" },        { :controller => "nodes", :action => "index" })
    assert_routing({ :method => "get",    :path => "/nodes/new" },    { :controller => "nodes", :action => "new" })
    assert_routing({ :method => "post",   :path => "/nodes" },        { :controller => "nodes", :action => "create" })
    assert_routing({ :method => "get",    :path => "/nodes/1" },      { :controller => "nodes", :action => "show",    :id => "1" })
    assert_routing({ :method => "get",    :path => "/nodes/1/edit" }, { :controller => "nodes", :action => "edit",    :id => "1" })
    assert_routing({ :method => "put",    :path => "/nodes/1" },      { :controller => "nodes", :action => "update",  :id => "1" })
    assert_routing({ :method => "delete", :path => "/nodes/1" },      { :controller => "nodes", :action => "destroy", :id => "1" })
  end

  def test_route_to_notes
    assert_routing({ :method => "get",    :path => "/notes" },        { :controller => "notes", :action => "index" })
    assert_routing({ :method => "get",    :path => "/notes/new" },    { :controller => "notes", :action => "new" })
    assert_routing({ :method => "post",   :path => "/notes" },        { :controller => "notes", :action => "create" })
    assert_routing({ :method => "get",    :path => "/notes/1" },      { :controller => "notes", :action => "show",    :id => "1" })
    assert_routing({ :method => "get",    :path => "/notes/1/edit" }, { :controller => "notes", :action => "edit",    :id => "1" })
    assert_routing({ :method => "put",    :path => "/notes/1" },      { :controller => "notes", :action => "update",  :id => "1" })
    assert_routing({ :method => "delete", :path => "/notes/1" },      { :controller => "notes", :action => "destroy", :id => "1" })
  end
end
