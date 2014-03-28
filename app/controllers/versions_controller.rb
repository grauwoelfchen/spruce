class VersionsController < ApplicationController
  before_filter :load_version

  def revert
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    redirect_to :back, :notice => "Undid #{@version.event}. #{redo_link}"
  end
  
  private

  def load_version
    @version = PaperTrail::Version
      .where(:id => params[:id], :user_id => current_user.id).first
    redirect_to root_url unless @version
  end

  def redo_link
    link_name = (params[:redo] == "true" ? "undo" : "redo")
    view_context.link_to(link_name, revert_version_path(@version.next, :redo => link_name != "undo"), :method => :post)
  end
end
