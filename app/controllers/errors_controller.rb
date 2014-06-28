class ErrorsController < ApplicationController
  def show
    render :not_found,
      :layout => "application.min",
      :status => status_code
  end

  private

  def status_code
    # pramas[:code]
    404
  end
end
