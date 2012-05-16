class CallbacksController < ApplicationController

  def callback
    handler = EncodingHandler::Factory.handle_profile params['profile_id']
    handler.perform params
    render :status => :ok, :json => "OK" , layout: false
  end

end