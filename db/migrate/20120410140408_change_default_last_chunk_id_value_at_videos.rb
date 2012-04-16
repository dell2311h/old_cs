class ChangeDefaultLastChunkIdValueAtVideos < ActiveRecord::Migration
  def up
    change_column :videos, :last_chunk_id, :integer, default: 0
  end

  def down
    change_column :videos, :last_chunk_id, :integer, default: nil
  end
end

