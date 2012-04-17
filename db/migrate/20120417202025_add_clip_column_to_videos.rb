class AddClipColumnToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :clip, :string

  end
end
