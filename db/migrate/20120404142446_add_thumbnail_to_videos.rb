class AddThumbnailToVideos < ActiveRecord::Migration
  def self.up
    change_table :videos do |t|
      t.has_attached_file :thumbnail
    end
  end

  def self.down
    drop_attached_file :videos, :thumbnail
  end
end
