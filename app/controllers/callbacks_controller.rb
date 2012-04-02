require "encoding_lib_worker"
class CallbacksController < ApplicationController

  def demux
      status, message = EncodingLib::Worker.callback :demux, params
      unless status == true
        render status: :bad_request, json: { error: message }, layout: false

        return
      end

      render :status => :ok, json:{ error: '' }, layout: false
  end
end