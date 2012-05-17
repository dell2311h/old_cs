class Worker::TimingsInterpretator

  @queue = :timings_queue

  def self.perform(event_id)
    event = Event.find event_id
    event.make_new_master_track
  end

end

