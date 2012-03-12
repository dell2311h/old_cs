class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token
  
  respond_to :json


  rescue_from Exception do |exeption|
    error = {:error => exeption.message}
    respond_with error, :status => :bad_request, :location => nil
  end
  
  # TODO here should be before_filer which will be set @current_user variable with current API user object
  
  
  protected
    
    # Method for validation of latitude and longitude params
    def valid_number?(string)
      string.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end

end

