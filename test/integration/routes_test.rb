require "test_helper"

class RoutesTest < ActionDispatch::IntegrationTest
  def test_route_to_sitemap
    assert_routing(
      {method: "get", path: "/sitemap.xml"},
      {controller: "sitemap", action: "index", format: "xml"})
  end

  def test_route_to_pages
    assert_routing(
      {method: "get", path: "/"},
      {controller: "pages", action: "index"})
    assert_routing(
      {method: "get", path: "/introduction"},
      {controller: "pages", action: "introduction"})
    assert_routing(
      {method: "get", path: "/changelog"},
      {controller: "pages", action: "changelog"})
    assert_routing(
      {method: "get", path: "/syntax"},
      {controller: "pages", action: "syntax"})
  end

  def test_route_to_sessions
    assert_routing(
      {method: "delete", path: "/logout"},
      {controller: "sessions", action: "destroy"})
    assert_routing(
      {method: "get", path: "/login"},
      {controller: "sessions", action: "new"})
    assert_routing(
      {method: "post", path: "/login"},
      {controller: "sessions", action: "create"})
  end

  def test_route_to_users
    assert_routing(
      {method: "get", path: "/signup"},
      {controller: "users", action: "new"})
    assert_routing(
      {method: "post", path: "/signup"},
      {controller: "users", action: "create"})
    assert_routing(
      {method: "get", path: "/users/token/activate"},
      {controller: "users", action: "activate", token: "token"})
  end

  def test_route_to_password_resets
    assert_routing(
      {method: "get", path: "/password_resets/new"},
      {controller: "password_resets", action: "new"})
    assert_routing(
      {method: "post", path: "/password_resets"},
      {controller: "password_resets", action: "create"})
    assert_routing(
      {method: "get", path: "/password_resets/token/edit"},
      {controller: "password_resets", action: "edit", token: "token"})
    assert_routing(
      {method: "put", path: "/password_resets/token"},
      {controller: "password_resets", action: "update", token: "token"})
    assert_routing(
      {method: "patch", path: "/password_resets/token"},
      {controller: "password_resets", action: "update", token: "token"})
  end

  def test_route_to_nodes
    assert_routing(
      {method: "get", path: "/b/1/b/new"},
      {controller: "nodes", action: "new", node_id: "1"})
    assert_routing(
      {method: "post", path: "/b/1/b"},
      {controller: "nodes", action: "create", node_id: "1"})
    assert_routing(
      {method: "get", path: "/b"},
      {controller: "nodes", action: "index"})
    assert_routing(
      {method: "get", path: "/b.txt"},
      {controller: "nodes", action: "index", format: "txt"})
    assert_routing(
      {method: "get", path: "/b/1"},
      {controller: "nodes", action: "show", id: "1"})
    assert_routing(
      {method: "get", path: "/b/1.txt"},
      {controller: "nodes", action: "show", id: "1", format: "txt"})
    assert_routing(
      {method: "get", path: "/b/1/edit"},
      {controller: "nodes", action: "edit", id: "1"})
    assert_routing(
      {method: "put", path: "/b/1"},
      {controller: "nodes", action: "update",  id: "1"})
    assert_routing(
      {method: "patch", path: "/b/1"},
      {controller: "nodes", action: "update",  id: "1"})
    assert_routing(
      {method: "get", path: "/b/1/delete"},
      {controller: "nodes", action: "delete", id: "1"})
    assert_routing(
      {method: "delete", path: "/b/1/delete"},
      {controller: "nodes", action: "destroy", id: "1"})
  end

  def test_route_to_notes
    assert_routing(
      {method: "get", path: "/b/1/l/new"},
      {controller: "notes", action: "new", node_id: "1"})
    assert_routing(
      {method: "post", path: "/b/1/l"},
      {controller: "notes", action: "create", node_id: "1"})
    assert_routing(
      {method: "get", path: "/l/1"},
      {controller: "notes", action: "show", id: "1"})
    assert_routing(
      {method: "get", path: "/l/1.txt"},
      {controller: "notes", action: "show", id: "1", format: "txt"})
    assert_routing(
      {method: "get", path: "/l/1/edit"},
      {controller: "notes", action: "edit", id: "1"})
    assert_routing(
      {method: "put", path: "/l/1"},
      {controller: "notes", action: "update", id: "1"})
    assert_routing(
      {method: "patch", path: "/l/1"},
      {controller: "notes", action: "update", id: "1"})
    assert_routing(
      {method: "get", path: "/l/1/delete"},
      {controller: "notes", action: "delete", id: "1"})
    assert_routing(
      {method: "delete", path: "/l/1/delete"},
      {controller: "notes", action: "destroy", id: "1"})
  end

  def test_route_to_versions
    assert_routing(
      {method: "get", path: "/v/1/l/revert"},
      {controller: "versions", action: "revert", id: "1", type: "l"}
    )
    assert_routing(
      {method: "get", path: "/v/1/b/revert"},
      {controller: "versions", action: "revert", id: "1", type: "b"}
    )
    assert_routing(
      {method: "post", path: "/v/1/l/revert"},
      {controller: "versions", action: "restore", id: "1", type: "l"}
    )
    assert_routing(
      {method: "post", path: "/v/1/b/revert"},
      {controller: "versions", action: "restore", id: "1", type: "b"}
    )
  end
end
