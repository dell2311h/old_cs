require "encoding_lib_demux"
class CallbacksController < ApplicationController

  def demux

    begin
      status = EncodingLib::Demux.demux_callback params
    rescue Exception => exeption
      render status: :bad_request, json: { error: exeption.message }, layout: false

      return
    end
    if status != true
      render :status => :bad_request, json: {:error => "Bad request"}, layout: false

      return
    else
      render :status => :ok, layout: false

      return
    end

  end
end