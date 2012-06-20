class MetaInfo < ActiveRecord::Base
  belongs_to :video

  validates :recorded_at, presence: true

  after_create :accure_achievement_points

  private

    def accure_achievement_points
      if Video.unscoped.find(self.video_id).event.videos.joins(:meta_info).order('meta_infos.duration DESC').first.id == self.video_id
        notify_observers(:after_upload_longest_video_to_event)
      end
    end
end
