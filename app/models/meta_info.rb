class MetaInfo < ActiveRecord::Base
  belongs_to :video

  validates :recorded_at, presence: true

  after_create :accure_achievement_points

  private

    def accure_achievement_points
      event_id = Video.unscoped.find(self.video_id).event_id
      if Video.unscoped.where(:event_id => event_id).joins(:meta_info).order('meta_infos.duration DESC').first.id == self.video_id
        notify_observers(:after_upload_longest_video_to_event)
      end
    end
end

