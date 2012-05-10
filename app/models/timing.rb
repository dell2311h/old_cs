class Timing < ActiveRecord::Base

  validates :video_id, :start_time, :end_time, :version, :presence => true
  validates :video_id, :start_time, :end_time, :version, :numericality => { :only_integer => true }

  belongs_to :video

  def create_by_pluraleyes_sync pe_sync_results = []

    # prepare PluralEyes results for timings creation
    groups_with_timestamp_and_duration = []
    pe_sync_results.each do |group|
      sorted_group = group.sort { |x, y| x[:start].to_i <=> y[:start].to_i }
      first_synched_clip = sorted_group[0]
      clip = Clip.find_by_pluraleyes_id first_synched_clip[:media_id]
      timestamp = clip.video.meta_info.recorded_at.to_i
      last_synched_clip = sorted_group.last
      group_duration = last_synched_clip[:end]
      groups_with_timestamp_and_duration << { pe_group: sorted_group, starts_at: timestamp, duration: group_duration }
    end

    # Sort groups by their chronological order
    groups_with_timestamp_and_duration.sort! { |x, y| x[:starts_at] <=> y[:starts_at] }

    # create timings by prepared PluralEyes results
    group_time_offset = 0 # miliseconds
    groups_with_timestamp_and_duration.each do |group|
      # group { :pe_group => [...], :starts_at => timestamp, :duration => miliseconds }
      pluraleyes_group = group[:pe_group]
      pluraleyes_group.each do |synced_clip|
        clip = Clip.find_by_pluraleyes_id synced_clip[:media_id]
        clip.video.timings.create! :start_time => synced_clip[:start], :end_time => synced_clip[:end], :version => ????
      end
      group_time_offset += group[:duration]
    end
  end

end

