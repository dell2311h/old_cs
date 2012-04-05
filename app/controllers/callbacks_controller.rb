class CallbacksController < ApplicationController

before_filter :set_processor

  def callback
    status, message = Video.send @process_method, params
    unless status == true
      render status: :bad_request, json: { errors: message }, layout: false

      return
    end

    render :status => :ok, json:{ errors: '' }, layout: false
  end

  private

    def set_processor
      @process_method = case params["method"]
                   when "demux"  then 'demux_ready'
                   when "stream" then 'stream_ready'
                   else raise 'Unknown action'
                   end
    end
end