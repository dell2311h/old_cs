class Worker::TimingsInterpretator

  @queue = :timings_queue

  def self.perform(event_id)
    event = Event.find event_id
    event.sync_with_pluraleyes

    # TODO: send master track creation request to Encoding Server

  end

end

