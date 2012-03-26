class AddEncodingIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :encoding_id, :string
  end
end
