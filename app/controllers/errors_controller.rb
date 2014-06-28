class ErrorsController < ApplicationController
  def show
    respond_to do |format|
      format.html {
        render :not_found, :layout => "error",
          :status => status_code
      }
      format.json {
        render :json => {:status => status_code},
          :status => status_code
      }
      format.xml {
        render :xml => {:status => status_code}.to_xml(:root => :error),
          :status => status_code
      }
      format.any {
        render :text => "Error #{status_code}",
          :status => status_code
      }
    end
  end

  private

  def status_code
    # pramas[:code]
    404
  end
end
