class VersionsController < ApplicationController
  before_filter :load_version

  def revert
    render :layout => "application.min"
  end

  def restore
    @version.restore!
    redirect_to back_url,
      :notice => "Undid #{@version.event}. #{redo_link}"
  end

  private

    def load_version
      @version = Version::Cycle
        .where(:id => params[:id], :user_id => current_user.id).first
      redirect_to root_url unless @version
    end

    def redo_link
      unless @version.next
        nil
      else
        text = params[:redo] == "true" ? "undo" : "redo"
        href = revert_version_path(
          @version.next, params[:type], :redo => text != "undo")
        view_context.link_to(text, href, :method => :post)
      end
    end

    def back_url
      if @version.item_type == "Note" && !@version.object
        node_url(@version.item.node)
      else
        request.referer && request.referer !~ /\/revert\/?/ ? :back : nodes_url
      end
    end
end
