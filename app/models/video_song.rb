class VideoSong < ActiveRecord::Base
  belongs_to :user
  belongs_to :song
  belongs_to :video

  validates :song_id, :video_id, presence: true

  after_create :accure_achievement_points

  private

    def accure_achievement_points
      unless self.user_id == Video.unscoped.where(:id => self.video_id).first.user_id
        if VideoSong.where(:video_id => self.video_id).order('created_at ASC').first.id == self.id
          notify_observers(:after_add_to_video)
        end
      end
    end
end
