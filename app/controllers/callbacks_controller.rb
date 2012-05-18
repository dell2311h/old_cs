class CallbacksController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def callback
    handler = EncodingHandler::Factory.handle_profile params['profile_id']
    handler.perform params
    render :status => :ok, :json => "OK" , layout: false
  end

end

