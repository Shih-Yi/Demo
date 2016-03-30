class AjaxtestController < ApplicationController
  def ajaxtest

    respond_to do |format|
      format.html { render :layout => false } # ajaxtest.html.erb
      format.json {
        render :json => { :hx => Time.now }
      }
      format.js # ajaxtest.js.erb
    end
  end
end
