class EncodingHandler::MetaInfo

  def self.perform params
    #encoding_id = params[:data][:input_media_ids][0]
    #video = Video.find_by_encoding_id encoding_id
    p '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    #tatus = EncodingApi::Factory.process_media :demux, encoding_id
    raise 'Unable to add video to demux' unless status
  end

end