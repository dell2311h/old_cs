class AddLastChunkIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :last_chunk_id, :integer
  end
end
