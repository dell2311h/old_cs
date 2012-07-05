class Worker::PluraleyesUploader

  @queue = :pluraleyes_queue

  def self.perform(clip_id)
    clip = Clip.find clip_id
    clip.add_to_pluraleyes
    event = clip.video.event
    Resque.enqueue(Worker::TimingsInterpretator, event.id) if event.sync_with_pluraleyes?
  end

end
