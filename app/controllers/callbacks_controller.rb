class CallbacksController < ApplicationController

before_filter :get_handler

  def callback
    EncodingHandler.handle @handler, params
    render :status => :ok, :json => "OK" , layout: false
  end

  private

    def get_handler
      profile = EncodingProfile.find_by_profile_id! params[:profile_id]
      @handler = profile.name
    end
end