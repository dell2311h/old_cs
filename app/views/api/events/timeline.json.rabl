
node :clips_count do |timeline|
  timeline[:size]
end

node :position do |timeline|
  timeline[:position]
end


node :clips do |timeline|
  timeline[:clips].each_with_index.map do |clip, index|
    { :id         => clip.id,
      :rating     => clip.rating,
      :position   => index,
      :start_time => clip.start_time,
      :duraton    => (clip.end_time - clip.start_time),
      :media      => clip.location,
      :username    => clip.user_name
    }
  end

end
