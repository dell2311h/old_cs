class Worker::PluraleyesUploader

  @queue = :pluraleyes_queue

  def self.perform(clip_id)
    clip = Clip.find clip_id
    clip.add_to_pluraleyes
  end

end
