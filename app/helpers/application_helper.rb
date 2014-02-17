module ApplicationHelper
  # Handles parent, child to consider its in shallow context.
  # if @node is given, `parent` is loaded via `@node.parent`.
  #
  # @param [Array<Node,Note>] @node or [@node, @note]
  # @return [Array<Array, Node>]
  def shallow_args(*args)
    obj = args.last
    if obj.try(:new_record?)
      args.length == 1 ? [obj.parent, obj] : args
    else
      obj
    end
  end

  def parentheses
    css_klass = "parenthesis-highlight"
    at_node    = (controller_name == "nodes")
    in_context = (action_name == "index" || (at_node && action_name == "show")) ? nil : css_klass
    {
      global: (at_node && action_name.in?(%w[index show])) ? css_klass : nil,
      node: at_node  ? in_context : nil,
      note: !at_node ? in_context : nil
    }
  end

  def render_paths(paths)
    "/ " + paths.map { |n|
      link_to(n.root? ? "root" : n.name, node_path(n))
    }.join(" / ")
  end
end
