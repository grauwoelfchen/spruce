module ApplicationHelper
  include ActionView::Helpers::UrlHelper

  alias_method :orig_current_page?, :current_page?
  def current_page?(args)
    options = if args.is_a?(String) && args =~ /^([A-z:]+)#([a-z]+)$/
                controller_class, method_name = $1, $2
                {
                  controller: '/' + controller_class.downcase.gsub(/::/, "/"),
                  action:     method_name
                }
              else
                args
              end
    orig_current_page?(url_for(options))
  end

  def current_page_in?(options)
    names = controller.class.name.downcase.split("::")
    here = if names.length > 1
             "#{names[0..-2].join("::")}::#{controller_name}##{action_name}"
           else
             "#{controller_name}##{action_name}"
           end
    here.in?(options.map(&:downcase))
  end

  def display_favicon_link(env)
    if env == "development"
      favicon_link_tag "/favicon-development.ico"
    else
      favicon_link_tag "/favicon.ico"
    end
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

  def parenthesis_styles
    style = "parenthesis-highlight"
    node  = controller_name == "nodes"
    note  = controller_name == "notes"
    edit  = action_name.in?(%w[index edit update])
    show  = action_name.in?(%w[show])
    new   = action_name.in?(%w[new create])
    styles = {
      node: {},
      note: {}
    }
    styles[:node][:edit] = style if node && edit
      styles[:node][:show] = style if node && show
        styles[:node][:new] = style if node && new
    styles[:note][:edit] = style if note && edit
      styles[:note][:show] = style if note && show
        styles[:note][:new] = style if note && new
    styles
  end

  def render_paths(paths)
    "/ " + paths.map { |n|
      if n.root?
        link_to("root", nodes_path)
      elsif params[:id] == n.id.to_s && current_page?("nodes#show")
        content_tag(:span, n.name, class: "pwd")
      else
        link_to(n.name, node_path(n))
      end
    }.join(" / ")
  end
end
