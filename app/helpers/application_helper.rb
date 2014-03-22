module ApplicationHelper
  include ActionView::Helpers::UrlHelper

  alias_method :orig_current_page?, :current_page?
  def current_page?(options)
    if options.is_a?(String) && options =~ /^([a-z]+)#([a-z]+)$/
      options = {controller: $1, action: $2}
    end
    orig_current_page?(url_for(options))
  end

  def current_page_in?(options)
    "#{controller_name}##{action_name}".in?(options)
  end

  # Handles parent, child to consider its in shallow context.
  # if @node is given, parent is loaded via @node.parent.
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
    at_node   = (controller_name == "nodes")
    in_edit   = action_name.in?(%w[index edit update])
    in_show   = action_name.in?(%w[show])
    in_new    = action_name.in?(%w[new create])
    {
      node: {
        edit: at_node && in_edit ? css_klass : nil,
        show: at_node && in_show ? css_klass : nil,
        new:  at_node && in_new  ? css_klass : nil
      },
      note: {
        edit: !at_node && in_edit ? css_klass : nil,
        show: !at_node && in_show ? css_klass : nil,
        new:  !at_node && in_new  ? css_klass : nil
      }
    }
  end

  def render_paths(paths)
    "/ " + paths.map { |n|
      if n.root?
        link_to("root", nodes_path)
      elsif params[:id] == n.id.to_s && current_page?("nodes#show")
        content_tag(:span, n.name)
      else
        link_to(n.name, node_path(n))
      end
    }.join(" / ")
  end
end
