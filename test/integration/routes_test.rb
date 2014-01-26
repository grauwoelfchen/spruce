require "test_helper"

class RoutesTest < ActionDispatch::IntegrationTest

  def test_route_to_pages
    assert_routing({ method: "get", path: "/" }, { controller: "pages", action: "index" })
  end

  def test_route_to_notes
    assert_routing({ method: "get",    path: "/notes" },        { controller: "notes", action: "index" })
    assert_routing({ method: "get",    path: "/notes/new" },    { controller: "notes", action: "new" })
    assert_routing({ method: "post",   path: "/notes" },        { controller: "notes", action: "create" })
    assert_routing({ method: "get",    path: "/notes/1" },      { controller: "notes", action: "show",    id: "1" })
    assert_routing({ method: "get",    path: "/notes/1/edit" }, { controller: "notes", action: "edit",    id: "1" })
    assert_routing({ method: "put",    path: "/notes/1" },      { controller: "notes", action: "update",  id: "1" })
    assert_routing({ method: "delete", path: "/notes/1" },      { controller: "notes", action: "destroy", id: "1" })
  end
end
