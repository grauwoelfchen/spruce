class VersionsController < ApplicationController
  before_filter :load_version

  def revert
    @version.revert!
    redirect_to back_url, :notice => "Undid #{@version.event}. #{redo_link}"
  end

  private

  def load_version
    klass = params[:type] == "b" ? Version::Ring : Version::Layer
    @version = klass
      .where(:id => params[:id], :user_id => current_user.id).first
    redirect_to root_url unless @version
  end

  def redo_link
    text = params[:redo] == "true" ? "undo" : "redo"
    view_context
      .link_to(text, revert_version_path(@version.next, params[:type], :redo => text != "undo"), :method => :post)
  end

  def back_url
    if @version.item_type == "Note" && !@version.object
      node_url(@version.item.node)
    else
      request.referer ? :back : nodes_url
    end
  end
end
